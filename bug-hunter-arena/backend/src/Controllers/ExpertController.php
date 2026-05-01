<?php
require_once __DIR__ . '/../../config/Database.php';

class ExpertController {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/experts?team_id=1
     * Retourne les experts d'une équipe avec leur avatar, coins et score.
     */
    public function getByTeam(): void {
        header('Content-Type: application/json');
        $teamId = (int)($_GET['team_id'] ?? 0);
        if (!$teamId) {
            http_response_code(400);
            echo json_encode(['error' => 'team_id requis']);
            return;
        }
        $stmt = $this->db->prepare(
            "SELECT e.id, e.technology_id, e.pseudo, e.avatar, e.coins, e.score, t.name AS tech_name
             FROM experts e
             JOIN technologies t ON t.id = e.technology_id
             WHERE e.team_id = ?"
        );
        $stmt->execute([$teamId]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    }

    /**
     * POST /api/experts/avatar
     * Met à jour l'avatar d'un expert.
     * Body: { expert_id, avatar }
     */
    public function updateAvatar(): void {
        header('Content-Type: application/json');
        $data = json_decode(file_get_contents('php://input'), true);
        if (!isset($data['expert_id'], $data['avatar'])) {
            http_response_code(400);
            echo json_encode(['error' => 'expert_id et avatar requis']);
            return;
        }
        $allowed = ['robot', 'ninja', 'alien', 'hacker', 'wizard', 'cyborg'];
        if (!in_array($data['avatar'], $allowed)) {
            http_response_code(400);
            echo json_encode(['error' => 'Avatar invalide']);
            return;
        }
        $this->db->prepare("UPDATE experts SET avatar = ? WHERE id = ?")
                 ->execute([$data['avatar'], (int)$data['expert_id']]);
        echo json_encode(['success' => true, 'avatar' => $data['avatar']]);
    }

    /**
     * POST /api/experts/hint
     * Achète un indice pour un quiz (coûte 5 coins).
     * Body: { expert_id, quiz_id }
     * Retourne: { hint, coins_left } ou erreur si pas assez de coins.
     */
    public function buyHint(): void {
        header('Content-Type: application/json');
        $data = json_decode(file_get_contents('php://input'), true);
        if (!isset($data['expert_id'], $data['quiz_id'])) {
            http_response_code(400);
            echo json_encode(['error' => 'expert_id et quiz_id requis']);
            return;
        }

        $expertId = (int)$data['expert_id'];
        $quizId   = (int)$data['quiz_id'];
        $cost     = 5;

        // Vérifier les coins disponibles
        $stmt = $this->db->prepare("SELECT coins FROM experts WHERE id = ?");
        $stmt->execute([$expertId]);
        $expert = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$expert || $expert['coins'] < $cost) {
            http_response_code(402);
            echo json_encode([
                'error'      => 'Coins insuffisants',
                'coins_left' => $expert['coins'] ?? 0,
                'cost'       => $cost
            ]);
            return;
        }

        // Déduire les coins
        $this->db->prepare("UPDATE experts SET coins = coins - ? WHERE id = ?")
                 ->execute([$cost, $expertId]);

        // Enregistrer l'achat
        $this->db->prepare(
            "INSERT INTO hints_used (expert_id, quiz_id, coins_spent) VALUES (?, ?, ?)"
        )->execute([$expertId, $quizId, $cost]);

        // Récupérer la bonne réponse comme indice
        $stmtHint = $this->db->prepare(
            "SELECT solution_text FROM answers WHERE quiz_id = ? AND is_correct = 1 LIMIT 1"
        );
        $stmtHint->execute([$quizId]);
        $hint = $stmtHint->fetchColumn();

        $newCoins = $expert['coins'] - $cost;

        echo json_encode([
            'hint'       => $hint ?: 'Cherche la logique du code...',
            'coins_left' => $newCoins,
            'cost'       => $cost
        ]);
    }
}
