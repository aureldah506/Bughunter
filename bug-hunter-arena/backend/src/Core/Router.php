<?php
require_once __DIR__ . '/../Controllers/QuizController.php';
require_once __DIR__ . '/../Controllers/AuthController.php';
require_once __DIR__ . '/../Controllers/LeaderboardController.php';
require_once __DIR__ . '/../Controllers/SpectatorController.php';
require_once __DIR__ . '/../Controllers/ExpertController.php';
require_once __DIR__ . '/../Controllers/AdminController.php';

class Router {
    public function run() {
        $uri    = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $method = strtoupper($_SERVER['REQUEST_METHOD']);

        if (strpos($uri, '/api/quiz/random') !== false && $method === 'GET') {
            (new QuizController())->getRandomQuiz();
        }
        elseif (strpos($uri, '/api/quiz/validate') !== false && $method === 'POST') {
            (new QuizController())->validateAnswer();
        }
        elseif (strpos($uri, '/api/auth/register') !== false && $method === 'POST') {
            (new AuthController())->register();
        }
        elseif (strpos($uri, '/api/auth/login') !== false && $method === 'POST') {
            (new AuthController())->login();
        }
        elseif (strpos($uri, '/api/leaderboard') !== false && $method === 'GET') {
            (new LeaderboardController())->index();
        }
        elseif (strpos($uri, '/api/spectator') !== false && $method === 'GET') {
            (new SpectatorController())->index();
        }
        elseif (strpos($uri, '/api/experts/avatar') !== false && $method === 'POST') {
            (new ExpertController())->updateAvatar();
        }
        elseif (strpos($uri, '/api/experts/hint') !== false && $method === 'POST') {
            (new ExpertController())->buyHint();
        }
        elseif (strpos($uri, '/api/experts') !== false && $method === 'GET') {
            (new ExpertController())->getByTeam();
        }
        elseif (strpos($uri, '/api/admin/reset') !== false && $method === 'POST') {
            (new AdminController())->reset();
        }
        elseif (strpos($uri, '/api/admin/stats') !== false && $method === 'GET') {
            (new AdminController())->stats();
        }
        else {
            header('Content-Type: application/json');
            http_response_code(404);
            echo json_encode(["error" => "Route non trouvée", "uri" => $uri]);
        }
    }
}
