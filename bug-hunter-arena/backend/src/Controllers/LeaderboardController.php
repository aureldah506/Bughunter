<?php
require_once __DIR__ . '/../../config/Database.php';

class LeaderboardController {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/leaderboard
     * Retourne toutes les équipes triées par score décroissant,
     * avec le détail des experts (score + coins) par équipe.
     */
    public function index(): void {
        header('Content-Type: application/json');
        try {
            $teams = $this->db->query(
                'SELECT id, name, score FROM teams ORDER BY score DESC'
            )->fetchAll(PDO::FETCH_ASSOC);

            // Ajouter les experts et l'historique des ratés pour chaque équipe
            $stmtExp = $this->db->prepare(
                "SELECT e.id, e.pseudo, e.avatar, e.score, e.coins, t.name AS tech_name
                 FROM experts e
                 JOIN technologies t ON t.id = e.technology_id
                 WHERE e.team_id = ?
                 ORDER BY e.score DESC"
            );
            $stmtHistory = $this->db->prepare(
                "SELECT tech_name, is_correct, points, correction, question_desc, question_code, solved_at
                 FROM bug_history
                 WHERE team_id = ?
                 ORDER BY solved_at DESC
                 LIMIT 20"
            );
            foreach ($teams as &$team) {
                $stmtExp->execute([$team['id']]);
                $team['experts'] = $stmtExp->fetchAll(PDO::FETCH_ASSOC);
                $stmtHistory->execute([$team['id']]);
                $team['history'] = $stmtHistory->fetchAll(PDO::FETCH_ASSOC);
            }

            echo json_encode($teams);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }
}
