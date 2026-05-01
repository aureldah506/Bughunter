<?php
require_once __DIR__ . '/../../config/Database.php';

class AdminController {
    private $db;
    private const ADMIN_KEY = 'bughunter2026'; // clé simple pour protéger les actions admin

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    private function checkKey(): bool {
        $data = json_decode(file_get_contents('php://input'), true);
        return ($data['admin_key'] ?? '') === self::ADMIN_KEY;
    }

    /**
     * POST /api/admin/reset
     * Remet tous les scores à 0 (équipes + experts) et vide l'historique.
     */
    public function reset(): void {
        header('Content-Type: application/json');
        if (!$this->checkKey()) {
            http_response_code(403);
            echo json_encode(['error' => 'Clé admin invalide']);
            return;
        }
        try {
            $this->db->exec('UPDATE teams SET score = 0');
            $this->db->exec('UPDATE experts SET score = 0, coins = 0');
            $this->db->exec('DELETE FROM bug_history');
            $this->db->exec('DELETE FROM hints_used');
            $this->db->exec('UPDATE game_session SET active_player = NULL, active_team_id = NULL, last_activity = NULL');
            echo json_encode(['success' => 'Scores réinitialisés, nouvelle partie prête']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    /**
     * GET /api/admin/stats
     * Retourne les statistiques globales.
     */
    public function stats(): void {
        header('Content-Type: application/json');
        try {
            $teams      = $this->db->query('SELECT COUNT(*) FROM teams')->fetchColumn();
            $quizzes    = $this->db->query('SELECT COUNT(*) FROM quizzes')->fetchColumn();
            $answers    = $this->db->query('SELECT COUNT(*) FROM bug_history')->fetchColumn();
            $correct    = $this->db->query('SELECT COUNT(*) FROM bug_history WHERE is_correct = 1')->fetchColumn();
            $hints      = $this->db->query('SELECT COUNT(*) FROM hints_used')->fetchColumn();
            $topTeam    = $this->db->query('SELECT name, score FROM teams ORDER BY score DESC LIMIT 1')->fetch();
            $topExpert  = $this->db->query('SELECT pseudo, score FROM experts ORDER BY score DESC LIMIT 1')->fetch();

            echo json_encode([
                'teams'          => (int)$teams,
                'quizzes'        => (int)$quizzes,
                'total_answers'  => (int)$answers,
                'correct_answers'=> (int)$correct,
                'hints_used'     => (int)$hints,
                'success_rate'   => $answers > 0 ? round(($correct / $answers) * 100) : 0,
                'top_team'       => $topTeam ?: null,
                'top_expert'     => $topExpert ?: null,
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }
}
