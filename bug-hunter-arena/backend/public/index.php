<?php
// backend/public/index.php

// 1. FORCER LES HEADERS CORS AVANT TOUTE CHOSE
header("Access-Control-Allow-Origin: http://localhost:4200");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Credentials: true");

// 2. RÉPONDRE IMMÉDIATEMENT AUX REQUÊTES OPTIONS (PREFLIGHT)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// 3. CONFIGURATION DES ERREURS
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// 4. LANCEMENT DU ROUTEUR
require_once __DIR__ . '/../src/Core/Router.php';

try {
    $router = new Router();
    $router->run();
} catch (Exception $e) {
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode([
        "error" => "Erreur interne",
        "message" => $e->getMessage()
    ]);
}