-- ============================================================
-- Bug Hunter Arena — Schéma complet
-- À importer une seule fois dans phpMyAdmin
-- ============================================================

CREATE DATABASE IF NOT EXISTS bug_hunter_arena
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bug_hunter_arena;

-- ------------------------------------------------------------
-- Équipes
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS teams (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    score      INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- Experts (un expert par techno par équipe)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS experts (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    team_id       INT NOT NULL,
    technology_id INT NOT NULL,
    pseudo        VARCHAR(100) NOT NULL,
    avatar        VARCHAR(50)  DEFAULT 'robot',
    coins         INT          DEFAULT 0,
    score         INT          DEFAULT 0,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Technologies
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS technologies (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT IGNORE INTO technologies (id, name) VALUES
    (1, 'PHP'),
    (2, 'ReactJS'),
    (3, 'C++'),
    (4, 'C#'),
    (5, 'Mobile');

-- ------------------------------------------------------------
-- Quiz (bugs à corriger)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS quizzes (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    technology_id   INT NOT NULL,
    bug_description TEXT NOT NULL,
    code_snippet    TEXT NOT NULL,
    FOREIGN KEY (technology_id) REFERENCES technologies(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Réponses QCM
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS answers (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id       INT NOT NULL,
    solution_text TEXT NOT NULL,
    is_correct    BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Historique des corrections
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bug_history (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    team_id    INT NOT NULL,
    expert_id  INT,
    quiz_id    INT NOT NULL,
    tech_name  VARCHAR(50) NOT NULL,
    is_correct TINYINT(1) DEFAULT 0,
    points     INT DEFAULT 0,
    solved_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id)   REFERENCES teams(id)   ON DELETE CASCADE,
    FOREIGN KEY (quiz_id)   REFERENCES quizzes(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Indices achetés (économie virtuelle)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS hints_used (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    expert_id   INT NOT NULL,
    quiz_id     INT NOT NULL,
    coins_spent INT DEFAULT 5,
    used_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expert_id) REFERENCES experts(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id)   REFERENCES quizzes(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Session de jeu (vue spectateur temps réel)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS game_session (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    current_tech    VARCHAR(50),
    current_quiz_id INT,
    active_player   VARCHAR(100),
    started_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
