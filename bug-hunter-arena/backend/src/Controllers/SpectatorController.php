<?php
require_once __DIR__ . '/../../config/Database.php';

class SpectatorController {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/spectator
     * Retourne toutes les données pour la vue spectateur :
     * - Classement des équipes
     * - Technologie en cours
     * - Joueur actif
     * - Historique des 10 derniers bugs corrigés
     */
    public function index(): void {
        header('Content-Type: application/json');
        try {
            // Classement avec experts
            $teams = $this->db->query(
                "SELECT id, name, score FROM teams ORDER BY score DESC"
            )->fetchAll(PDO::FETCH_ASSOC);

            $stmtExp = $this->db->prepare(
                "SELECT e.id, e.pseudo, e.avatar, e.score, e.coins, t.name AS tech_name
                 FROM experts e
                 JOIN technologies t ON t.id = e.technology_id
                 WHERE e.team_id = ?
                 ORDER BY e.score DESC"
            );
            foreach ($teams as &$team) {
                $stmtExp->execute([$team['id']]);
                $team['experts'] = $stmtExp->fetchAll(PDO::FETCH_ASSOC);
            }

            // Session en cours (active seulement si activité dans les 10 dernières minutes)
            $session = $this->db->query(
                "SELECT current_tech, active_player, active_team_id, last_activity
                 FROM game_session
                 ORDER BY id DESC LIMIT 1"
            )->fetch(PDO::FETCH_ASSOC);

            // Si la session date de plus de 10 min, on la considère inactive
            $isActive = false;
            if ($session && !empty($session['last_activity'])) {
                $lastActivity = strtotime($session['last_activity']);
                $isActive = (time() - $lastActivity) < 600; // 10 minutes
            }

            if (!$isActive) {
                $session = ['current_tech' => null, 'active_player' => null, 'active_team_id' => null];
            }

            // Experts de l'équipe active avec leurs technos
            $activeExperts = [];
            $activeTeamId  = $session['active_team_id'] ?? null;

            // Fallback : chercher l'équipe par son nom si active_team_id est vide
            if (!$activeTeamId && !empty($session['active_player'])) {
                $stmtFind = $this->db->prepare("SELECT id FROM teams WHERE name = ? LIMIT 1");
                $stmtFind->execute([$session['active_player']]);
                $activeTeamId = $stmtFind->fetchColumn() ?: null;
            }

            if ($activeTeamId) {
                $stmtExp = $this->db->prepare(
                    "SELECT e.pseudo, e.avatar, e.score, e.coins, t.name AS tech_name
                     FROM experts e
                     JOIN technologies t ON t.id = e.technology_id
                     WHERE e.team_id = ?
                     ORDER BY t.id"
                );
                $stmtExp->execute([$activeTeamId]);
                $activeExperts = $stmtExp->fetchAll(PDO::FETCH_ASSOC);
            }

            // Historique des 10 derniers bugs corrigés
            $history = $this->db->query(
                "SELECT bh.tech_name, bh.is_correct, bh.points, bh.solved_at,
                        bh.correction, bh.question_desc, bh.question_code,
                        t.name AS team_name
                 FROM bug_history bh
                 JOIN teams t ON t.id = bh.team_id
                 ORDER BY bh.solved_at DESC
                 LIMIT 10"
            )->fetchAll(PDO::FETCH_ASSOC);

            echo json_encode([
                'teams'          => $teams,
                'current_tech'   => $session['current_tech']   ?? null,
                'active_player'  => $session['active_player']  ?? null,
                'active_experts' => $activeExperts,
                'history'        => $history
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }
}
