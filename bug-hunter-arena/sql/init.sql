-- sql/init.sql

CREATE DATABASE IF NOT EXISTS bug_hunter_arena CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bug_hunter_arena;

-- Table des équipes
CREATE TABLE teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- C'est ça qui manquait !
    score INT DEFAULT 0,
    -- On ajoute des colonnes pour stocker tes 5 experts
    expert_php VARCHAR(100),
    expert_react VARCHAR(100),
    expert_cpp VARCHAR(100),
    expert_csharp VARCHAR(100),
    expert_mobile VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Table des technologies (PHP, JS, C++, C#, Mobile)
CREATE TABLE technologies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Table des bugs/quiz
CREATE TABLE quizzes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    technology_id INT NOT NULL,
    bug_description TEXT NOT NULL,
    code_snippet TEXT NOT NULL,
    FOREIGN KEY (technology_id) REFERENCES technologies(id) ON DELETE CASCADE
);

-- Table des réponses possibles pour le QCM
CREATE TABLE answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id INT NOT NULL,
    solution_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);