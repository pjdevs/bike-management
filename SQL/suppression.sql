-- ============================================================
--    Suppression d'utilisateurs 
-- ============================================================

-- Delete tout les utilisateurs & conserve les emprunts
SET foreign_key_checks = 0;
DELETE FROM ADHERENTS;
SET foreign_key_checks = 1;

-- Delete tout les utilisateurs & supprime les emprunts
DELETE FROM EMPRUNTS;
DELETE FROM ADHERENTS;

-- Delete un utilisateur et ses trajets précédents
DELETE FROM EMPRUNTS WHERE ID_ADHERENT=1;
DELETE FROM ADHERENTS WHERE ID_ADHERENT=1;