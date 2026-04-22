<?php
// backend/src/Controllers/QuizController.php

require_once __DIR__ . '/../Models/Question.php';
require_once __DIR__ . '/../Models/Team.php';

class QuizController {
    
    // --------------------------------------------------------
    // 1. Récupérer un bug aléatoire
    // --------------------------------------------------------
    public function getRandomQuiz() {
        header('Content-Type: application/json');

        if (!isset($_GET['tech']) || empty($_GET['tech'])) {
            http_response_code(400);
            echo json_encode(["error" => "Le paramètre 'tech' est requis (ex: ?tech=1)."]);
            return;
        }

        $tech_id = (int) $_GET['tech'];
        
        $questionModel = new Question();
        $quiz = $questionModel->getRandomByTech($tech_id);

        if ($quiz) {
            http_response_code(200);
            echo json_encode($quiz);
        } else {
            http_response_code(404);
            echo json_encode(["error" => "Aucun quiz trouvé pour la technologie ID: " . $tech_id]);
        }
    }

    // --------------------------------------------------------
    // 2. Valider la réponse envoyée par le joueur
    // --------------------------------------------------------
    public function validateAnswer() {
        header('Content-Type: application/json');
        
        $data = json_decode(file_get_contents("php://input"), true);

        if (!isset($data['team_id']) || !isset($data['answer_id'])) {
            http_response_code(400);
            echo json_encode(["error" => "team_id et answer_id sont requis."]);
            return;
        }

        $team_id = (int) $data['team_id'];
        $answer_id = (int) $data['answer_id'];

        $questionModel = new Question();
        $is_correct = $questionModel->checkAnswer($answer_id);

        $points_awarded = 0;
        $teamModel = new Team();

        if ($is_correct) {
            $points_awarded = 10; 
            $teamModel->addPoints($team_id, $points_awarded);
        }

        $new_score = $teamModel->getScore($team_id);

        http_response_code(200);
        echo json_encode([
            "correct" => $is_correct,
            "points_awarded" => $points_awarded,
            "message" => $is_correct ? "Bug corrigé avec succès !" : "Mauvaise correction, le bug est toujours là.",
            "new_score" => $new_score
        ]);
    }
}