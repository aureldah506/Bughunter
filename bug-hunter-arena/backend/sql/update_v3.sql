USE bug_hunter_arena;

-- Ajouter la colonne correction dans bug_history
ALTER TABLE bug_history ADD COLUMN correction TEXT DEFAULT NULL;
