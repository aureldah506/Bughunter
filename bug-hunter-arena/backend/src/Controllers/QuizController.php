<?php
require_once __DIR__ . '/../../config/Database.php';

class QuizController {
    private $db;

    private const TECH_NAMES = [
        1 => 'PHP', 2 => 'ReactJS', 3 => 'C++', 4 => 'C#', 5 => 'Mobile'
    ];

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/quiz/random?tech={id}
     * Retourne un quiz aléatoire pour une technologie donnée.
     */
    public function getRandomQuiz(): void {
        header('Content-Type: application/json');
        try {
            $techId  = isset($_GET['tech']) ? (int)$_GET['tech'] : null;
            // IDs déjà vus dans la session (envoyés par le frontend)
            $seenIds = isset($_GET['seen']) ? array_map('intval', explode(',', $_GET['seen'])) : [];

            $sql = "SELECT q.id, q.technology_id,
                           q.bug_description AS description,
                           q.code_snippet    AS code,
                           t.name            AS tech_name
                    FROM quizzes q
                    JOIN technologies t ON t.id = q.technology_id";

            $conditions = [];
            if ($techId) $conditions[] = "q.technology_id = $techId";
            if (!empty($seenIds)) {
                $ids = implode(',', $seenIds);
                $conditions[] = "q.id NOT IN ($ids)";
            }
            if ($conditions) $sql .= ' WHERE ' . implode(' AND ', $conditions);
            $sql .= " ORDER BY RAND() LIMIT 1";

            $quiz = $this->db->query($sql)->fetch(PDO::FETCH_ASSOC);

            // Si tous les quiz ont été vus, on réinitialise (fallback)
            if (!$quiz && !empty($seenIds)) {
                $fallback = "SELECT q.id, q.technology_id,
                                    q.bug_description AS description,
                                    q.code_snippet    AS code,
                                    t.name            AS tech_name
                             FROM quizzes q
                             JOIN technologies t ON t.id = q.technology_id";
                if ($techId) $fallback .= " WHERE q.technology_id = $techId";
                $fallback .= " ORDER BY RAND() LIMIT 1";
                $quiz = $this->db->query($fallback)->fetch(PDO::FETCH_ASSOC);
            }

            if (!$quiz) {
                http_response_code(404);
                echo json_encode(["error" => "Aucun quiz trouvé"]);
                return;
            }

            $stmt = $this->db->prepare(
                "SELECT id, solution_text, is_correct FROM answers WHERE quiz_id = ? ORDER BY RAND()"
            );
            $stmt->execute([$quiz['id']]);
            $quiz['answers'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $this->updateGameSession($quiz['id'], $quiz['tech_name'] ?? '');

            echo json_encode($quiz);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(["error" => $e->getMessage()]);
        }
    }

    /**
     * POST /api/quiz/validate
     * Valide la réponse, enregistre dans l'historique, met à jour le score.
     * Body: { quiz_id, answer_id, team_id, player_name? }
     */
    public function validateAnswer(): void {
        header('Content-Type: application/json');
        $data = json_decode(file_get_contents('php://input'), true);

        if (!isset($data['quiz_id'], $data['answer_id'], $data['team_id'])) {
            http_response_code(400);
            echo json_encode(["error" => "Données incomplètes"]);
            return;
        }

        try {
            // Vérifier la réponse
            $stmt = $this->db->prepare(
                "SELECT is_correct FROM answers WHERE id = ? AND quiz_id = ?"
            );
            $stmt->execute([$data['answer_id'], $data['quiz_id']]);
            $answer = $stmt->fetch(PDO::FETCH_ASSOC);

            $isCorrect = ($answer && $answer['is_correct'] == 1);
            $points    = $isCorrect ? 10 : 0;

            // Récupérer le nom de la techno pour l'historique
            $stmtTech = $this->db->prepare(
                "SELECT t.name FROM quizzes q JOIN technologies t ON t.id = q.technology_id WHERE q.id = ?"
            );
            $stmtTech->execute([$data['quiz_id']]);
            $techName = $stmtTech->fetchColumn() ?: 'Inconnue';

            // Récupérer la question + la bonne réponse pour l'historique
            $stmtQuiz = $this->db->prepare(
                "SELECT bug_description, code_snippet FROM quizzes WHERE id = ?"
            );
            $stmtQuiz->execute([$data['quiz_id']]);
            $quiz = $stmtQuiz->fetch(PDO::FETCH_ASSOC);

            $stmtCorrect = $this->db->prepare(
                "SELECT solution_text FROM answers WHERE quiz_id = ? AND is_correct = 1 LIMIT 1"
            );
            $stmtCorrect->execute([$data['quiz_id']]);
            $correction = $stmtCorrect->fetchColumn() ?: '';

            $stmtHist = $this->db->prepare(
                "INSERT INTO bug_history (team_id, quiz_id, tech_name, is_correct, points, correction, question_desc, question_code)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
            );
            $stmtHist->execute([
                $data['team_id'],
                $data['quiz_id'],
                $techName,
                $isCorrect ? 1 : 0,
                $points,
                $correction,
                $quiz['bug_description'] ?? '',
                $quiz['code_snippet']    ?? ''
            ]);

            // Mettre à jour le score si correct
            if ($isCorrect) {
                $this->db->prepare("UPDATE teams SET score = score + 10 WHERE id = ?")
                         ->execute([$data['team_id']]);

                // Créditer l'expert : +10 score, +10 coins (1 pt = 1 coin)
                if (!empty($data['expert_id'])) {
                    $this->db->prepare(
                        "UPDATE experts SET score = score + 10, coins = coins + 10 WHERE id = ?"
                    )->execute([(int)$data['expert_id']]);
                }
            }

            // Mettre à jour l'équipe active dans la session (pour la vue spectateur)
            $stmtTeamName = $this->db->prepare("SELECT name FROM teams WHERE id = ?");
            $stmtTeamName->execute([$data['team_id']]);
            $teamName2 = $stmtTeamName->fetchColumn();
            if ($teamName2) {
                $this->db->prepare(
                    "UPDATE game_session SET active_player = ?, active_team_id = ?, last_activity = NOW() ORDER BY id DESC LIMIT 1"
                )->execute([$teamName2, $data['team_id']]);
            }

            echo json_encode([
                "correct" => $isCorrect,
                "points"  => $points,
                "message" => $isCorrect ? "Bug corrigé ! +10 pts" : "L'anomalie persiste..."
            ]);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(["error" => $e->getMessage()]);
        }
    }

    /**
     * Met à jour la session de jeu pour la vue spectateur.
     */
    private function updateGameSession(int $quizId, string $techName): void {
        try {
            $count = $this->db->query("SELECT COUNT(*) FROM game_session")->fetchColumn();
            if ($count == 0) {
                $this->db->prepare(
                    "INSERT INTO game_session (current_quiz_id, current_tech, last_activity) VALUES (?, ?, NOW())"
                )->execute([$quizId, $techName]);
            } else {
                $this->db->prepare(
                    "UPDATE game_session SET current_quiz_id = ?, current_tech = ?, last_activity = NOW() ORDER BY id DESC LIMIT 1"
                )->execute([$quizId, $techName]);
            }
        } catch (Exception $e) {
            // Non bloquant
        }
    }}
