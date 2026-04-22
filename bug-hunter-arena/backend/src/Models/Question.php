<?php
// backend/src/Models/Question.php

require_once __DIR__ . '/../../config/Database.php';

class Question {
    private $conn;

    public function __construct() {
        $this->conn = Database::getInstance()->getConnection();
    }

    // --------------------------------------------------------
    // 1. Récupérer un bug aléatoire avec ses réponses
    // --------------------------------------------------------
    public function getRandomByTech($tech_id) {
        try {
            // Piocher un quiz au hasard pour cette techno
            $query = "SELECT id, technology_id, bug_description, code_snippet 
                      FROM quizzes 
                      WHERE technology_id = :tech_id 
                      ORDER BY RAND() LIMIT 1";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':tech_id', $tech_id, PDO::PARAM_INT);
            $stmt->execute();
            $quiz = $stmt->fetch();

            if (!$quiz) {
                return null;
            }

            // Récupérer les 4 réponses associées sans la colonne 'is_correct'
            $queryAnswers = "SELECT id, solution_text FROM answers WHERE quiz_id = :quiz_id";
            $stmtAnswers = $this->conn->prepare($queryAnswers);
            $stmtAnswers->bindParam(':quiz_id', $quiz['id'], PDO::PARAM_INT);
            $stmtAnswers->execute();
            
            $quiz['answers'] = $stmtAnswers->fetchAll();

            return $quiz;

        } catch(PDOException $e) {
            return null; 
        }
    }

    // --------------------------------------------------------
    // 2. Vérifier si une réponse est correcte
    // --------------------------------------------------------
    public function checkAnswer($answer_id) {
        $query = "SELECT is_correct FROM answers WHERE id = :answer_id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':answer_id', $answer_id, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $stmt->fetch();
        
        // Retourne true si c'est correct (1), false sinon (0 ou non trouvé)
        return $result ? (bool)$result['is_correct'] : false;
    }
}