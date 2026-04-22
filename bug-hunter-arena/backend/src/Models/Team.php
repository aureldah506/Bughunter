<?php
// backend/src/Models/Team.php

require_once __DIR__ . '/../../config/Database.php';

class Team {
    private $conn;

    public function __construct() {
        $this->conn = Database::getInstance()->getConnection();
    }

    /**
     * Inscription d'une équipe avec ses 5 experts (Transaction SQL)
     */
    public function registerFullTeam($teamName, $password, $expertsList) {
        try {
            // Début de la transaction pour s'assurer que tout est créé ou rien
            $this->conn->beginTransaction();

            // 1. Création de l'équipe
            $hashed = password_hash($password, PASSWORD_BCRYPT);
            $stmt = $this->conn->prepare("INSERT INTO teams (name, password) VALUES (:name, :password)");
            $stmt->execute([
                ':name' => $teamName,
                ':password' => $hashed
            ]);
            $teamId = $this->conn->lastInsertId();

            // 2. Création des 5 experts
            // $expertsList doit être un tableau associatif : [tech_id => pseudo]
            $stmtEx = $this->conn->prepare("INSERT INTO experts (team_id, technology_id, pseudo) VALUES (:team_id, :tech_id, :pseudo)");
            
            foreach ($expertsList as $techId => $pseudo) {
                $stmtEx->execute([
                    ':team_id' => $teamId,
                    ':tech_id' => $techId,
                    ':pseudo' => $pseudo
                ]);
            }

            // Validation de la transaction
            $this->conn->commit();
            return $teamId;

        } catch (Exception $e) {
            // En cas d'erreur, on annule tout ce qui a été fait
            $this->conn->rollBack();
            return false;
        }
    }

    /**
     * Authentification de l'équipe
     */
    public function login($name, $password) {
        $query = "SELECT id, name, password, score FROM teams WHERE name = :name";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':name', $name);
        $stmt->execute();

        $team = $stmt->fetch();

        if ($team && password_verify($password, $team['password'])) {
            unset($team['password']); // On ne renvoie pas le hash au front
            return $team;
        }
        return false;
    }

    /**
     * Mise à jour du score
     */
    public function addPoints($team_id, $points) {
        $query = "UPDATE teams SET score = score + :points WHERE id = :team_id";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([
            ':points' => $points,
            ':team_id' => $team_id
        ]);
        return $stmt->rowCount() > 0;
    }

    /**
     * Récupération du score actuel
     */
    public function getScore($team_id) {
        $query = "SELECT score FROM teams WHERE id = :team_id";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([':team_id' => $team_id]);
        return $stmt->fetchColumn();
    }

    /**
     * Récupération du classement général (Top 10)
     */
    public function getLeaderboard() {
        $query = "SELECT name, score FROM teams ORDER BY score DESC LIMIT 10";
        $stmt = $this->conn->query($query);
        return $stmt->fetchAll();
    }
}