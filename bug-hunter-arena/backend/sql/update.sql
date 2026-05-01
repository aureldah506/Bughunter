USE bug_hunter_arena;

-- Historique des bugs corrigés
CREATE TABLE IF NOT EXISTS bug_history (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    team_id    INT NOT NULL,
    quiz_id    INT NOT NULL,
    tech_name  VARCHAR(50) NOT NULL,
    is_correct TINYINT(1) DEFAULT 0,
    points     INT DEFAULT 0,
    solved_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- Session de jeu en cours (pour la vue spectateur)
CREATE TABLE IF NOT EXISTS game_session (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    current_tech VARCHAR(50),
    current_quiz_id INT,
    active_player VARCHAR(100),
    started_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (current_quiz_id) REFERENCES quizzes(id) ON DELETE SET NULL
);
