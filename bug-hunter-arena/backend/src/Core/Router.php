<?php
// backend/src/Core/Router.php

require_once __DIR__ . '/../Controllers/QuizController.php';
require_once __DIR__ . '/../Controllers/AuthController.php'; // N'oublie pas cet include !

class Router {
    public function run() {
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $method = $_SERVER['REQUEST_METHOD'];

        // --- ROUTES API QUIZ ---
        if (strpos($uri, '/api/quiz/random') !== false && $method === 'GET') {
            $controller = new QuizController();
            $controller->getRandomQuiz();
        } 
        elseif (strpos($uri, '/api/quiz/validate') !== false && $method === 'POST') {
            $controller = new QuizController();
            $controller->validateAnswer();
        }
        
        // --- ROUTES API AUTHENTIFICATION ---
        elseif (strpos($uri, '/api/auth/register') !== false && $method === 'POST') {
            $controller = new AuthController();
            $controller->register();
        }
        elseif (strpos($uri, '/api/auth/login') !== false && $method === 'POST') {
            $controller = new AuthController();
            $controller->login();
        }
        
        // --- 404 NOT FOUND ---
        else {
            header('Content-Type: application/json');
            http_response_code(404);
            echo json_encode(["error" => "Route API non trouvée."]);
        }
    }
}