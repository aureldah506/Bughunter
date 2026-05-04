<?php
// backend/src/Controllers/AuthController.php

// On remonte de 2 niveaux pour atteindre le dossier config à la racine du backend
require_once __DIR__ . '/../../config/Database.php';

class AuthController {
    private $db;

    public function __construct() {
        // Récupération de la connexion via le Singleton Database
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Gère l'inscription d'une nouvelle escouade
     */
    public function register() {
        // 1. Récupération des données JSON envoyées par Angular
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        // Validation minimale
        if (!$data || !isset($data['name']) || !isset($data['password'])) {
            http_response_code(400);
            echo json_encode(["error" => "Données d'escouade incomplètes."]);
            return;
        }

        try {
            // 2. Insertion de l'équipe dans la table 'teams'
            $stmt = $this->db->prepare("INSERT INTO teams (name, password) VALUES (:name, :pass)");
            $stmt->execute([
                'name' => $data['name'],
                'pass' => password_hash($data['password'], PASSWORD_BCRYPT)
            ]);
            
            $teamId = $this->db->lastInsertId();

            // 3. Insertion des experts dans la table 'experts'
            if (isset($data['experts']) && is_array($data['experts'])) {
                foreach ($data['experts'] as $techId => $pseudo) {
                    // On n'enregistre l'expert que si un pseudo a été saisi
                    if (!empty(trim($pseudo))) {
                        $stmtExp = $this->db->prepare("INSERT INTO experts (team_id, technology_id, pseudo) VALUES (?, ?, ?)");
                        $stmtExp->execute([$teamId, $techId, $pseudo]);
                    }
                }
            }

            echo json_encode(["message" => "L'escouade '" . $data['name'] . "' a été initialisée avec succès !"]);

        } catch (PDOException $e) {
            // Gestion des erreurs (ex: nom d'équipe déjà pris)
            http_response_code(500);
            if ($e->getCode() == 23000) {
                echo json_encode(["error" => "Ce nom d'escouade est déjà utilisé par une autre unité."]);
            } else {
                echo json_encode(["error" => "Échec du protocole d'inscription", "details" => $e->getMessage()]);
            }
        }
    }

    /**
     * POST /api/auth/logout
     * Efface l'équipe active dans game_session.
     */
    public function logout(): void {
        header('Content-Type: application/json');
        try {
            $this->db->exec(
                "UPDATE game_session SET active_player = NULL, active_team_id = NULL, last_activity = NULL ORDER BY id DESC LIMIT 1"
            );
            echo json_encode(['success' => true]);
        } catch (Exception $e) {
            echo json_encode(['success' => true]); // non bloquant
        }
    }

    /**
     * Gère la connexion d'une escouade existante
     */
    public function login() {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (!$data || !isset($data['name']) || !isset($data['password'])) {
            http_response_code(400);
            echo json_encode(["error" => "Identifiants manquants."]);
            return;
        }

        try {
            // 1. Recherche de l'équipe
            $stmt = $this->db->prepare("SELECT * FROM teams WHERE name = ?");
            $stmt->execute([$data['name']]);
            $team = $stmt->fetch(PDO::FETCH_ASSOC);

            // 2. Vérification du mot de passe
            if ($team && password_verify($data['password'], $team['password'])) {
                
                // 3. Récupération des experts associés pour le Dashboard
                $stmtExp = $this->db->prepare("SELECT technology_id, pseudo FROM experts WHERE team_id = ?");
                $stmtExp->execute([$team['id']]);
                $expertsList = $stmtExp->fetchAll(PDO::FETCH_ASSOC);
                
                // Formatage des experts pour Angular (id_techno => pseudo)
                $experts = [];
                foreach ($expertsList as $exp) {
                    $experts[$exp['technology_id']] = $exp['pseudo'];
                }

                // Réponse propre pour le frontend
                echo json_encode([
                    "message" => "Accès autorisé.",
                    "team" => [
                        "id" => $team['id'],
                        "name" => $team['name'],
                        "score" => (int)$team['score'],
                        "experts" => $experts
                    ]
                ]);

                // Mettre à jour la session active pour la vue spectateur
                try {
                    $count = $this->db->query("SELECT COUNT(*) FROM game_session")->fetchColumn();
                    if ($count > 0) {
                        $this->db->prepare(
                            "UPDATE game_session SET active_player = ?, active_team_id = ?, last_activity = NOW() ORDER BY id DESC LIMIT 1"
                        )->execute([$team['name'], $team['id']]);
                    }
                } catch (Exception $e) { /* non bloquant */ }
            } else {
                http_response_code(401);
                echo json_encode(["error" => "Nom d'escouade ou code d'accès invalide."]);
            }

        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(["error" => "Erreur système lors de l'authentification."]);
        }
    }
}