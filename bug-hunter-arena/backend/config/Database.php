<?php
// backend/config/Database.php

class Database {
    // Instance unique de la classe (Singleton)
    private static $instance = null;
    private $conn;

    // Identifiants de base de données (à adapter selon ton environnement local comme XAMPP/WAMP/MAMP)
    private $host = 'localhost';
    private $db_name = 'bug_hunter_arena';
    private $username = 'root';
    private $password = ''; 

    // Le constructeur est privé pour empêcher la création directe d'objets avec "new"
    private function __construct() {
        try {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";charset=utf8mb4", $this->username, $this->password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            // On récupère les données sous forme de tableau associatif par défaut
            $this->conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        } catch(PDOException $e) {
            die("Erreur de connexion à la base de données : " . $e->getMessage());
        }
    }

    // Méthode pour récupérer l'instance unique
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    // Méthode pour récupérer l'objet PDO et faire des requêtes
    public function getConnection() {
        return $this->conn;
    }
}