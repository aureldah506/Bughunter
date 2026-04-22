<?php
// backend/src/Controllers/AuthController.php

require_once __DIR__ . '/../Models/Team.php';

class AuthController {
    
    // Inscription d'une équipe complète
    public function register() {
        header('Content-Type: application/json');
        $data = json_decode(file_get_contents("php://input"), true);

        // Validation basique des données
        if (empty($data['name']) || empty($data['password']) || empty($data['experts']) || count($data['experts']) !== 5) {
            http_response_code(400);
            echo json_encode([
                "error" => "Données incomplètes. Il faut un nom d'équipe, un mot de passe et exactement 5 experts."
            ]);
            return;
        }

        $teamModel = new Team();
        
        // On appelle notre nouvelle méthode qui fait tout en une seule transaction
        $teamId = $teamModel->registerFullTeam($data['name'], $data['password'], $data['experts']);

        if ($teamId) {
            http_response_code(201);
            echo json_encode([
                "message" => "Équipe '{$data['name']}' créée avec succès ! Que la chasse aux bugs commence.", 
                "team_id" => $teamId
            ]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Erreur lors de l'inscription. Ce nom d'équipe est peut-être déjà pris."]);
        }
    }

    // Connexion
    public function login() {
        header('Content-Type: application/json');
        $data = json_decode(file_get_contents("php://input"), true);

        if (empty($data['name']) || empty($data['password'])) {
            http_response_code(400);
            echo json_encode(["error" => "Le nom de l'équipe et le mot de passe sont requis."]);
            return;
        }

        $teamModel = new Team();
        $team = $teamModel->login($data['name'], $data['password']);

        if ($team) {
            // Optionnel : on pourrait aussi récupérer la liste des experts ici pour l'envoyer au front
            http_response_code(200);
            echo json_encode([
                "message" => "Connexion réussie", 
                "team" => $team
            ]);
        } else {
            http_response_code(401);
            echo json_encode(["error" => "Identifiants incorrects."]);
        }
    }
}