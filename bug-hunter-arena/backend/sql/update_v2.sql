USE bug_hunter_arena;

-- Ajout des colonnes avatar, coins et score sur les experts
-- (sans IF NOT EXISTS, compatible toutes versions MySQL)
ALTER TABLE experts
    ADD COLUMN avatar VARCHAR(50) DEFAULT 'robot',
    ADD COLUMN coins  INT         DEFAULT 0,
    ADD COLUMN score  INT         DEFAULT 0;

-- Historique des indices achetés
CREATE TABLE IF NOT EXISTS hints_used (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    expert_id   INT NOT NULL,
    quiz_id     INT NOT NULL,
    coins_spent INT DEFAULT 5,
    used_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expert_id) REFERENCES experts(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id)   REFERENCES quizzes(id) ON DELETE CASCADE
);
