-- ============================================================
--    Mise à jour de la base
-- ============================================================

    -- ==============================
    --    Création d'un trajet 
    -- ==============================




    -- ==============================
    --    Suppression 
    -- ==============================


-- Prodécure : Supprime tout les adhérents et on met à jour les ID adhérents des emprunts
-- Appel exemple: CALL delete_adherent_all(); => Tous les utilisateurs sont supprimés et les emprunts mis à jour

DELIMITER //
CREATE PROCEDURE delete_adherent_all()
BEGIN

SET foreign_key_checks = 0;
UPDATE EMPRUNTS SET ID_ADHERENT=-1;
DELETE FROM ADHERENTS; 
SET foreign_key_checks = 1;

END //
DELIMITER ;


-- Prodécure : Supprime un adherent spécifique et on met à jour les ID adhérents des emprunts
-- Appel exemple: CALL delete_adherent_id(2); => L'utilisateur 2 est supprimé et ses emprunts sont mis à jour

DELIMITER //
CREATE PROCEDURE delete_adherent_id
(IN id INT)
BEGIN

SET foreign_key_checks = 0;
UPDATE EMPRUNTS SET ID_ADHERENT=-1 WHERE ID_ADHERENT=id;
DELETE FROM ADHERENTS WHERE ID_ADHERENT=id; 
SET foreign_key_checks = 1;

END //
DELIMITER ;


-- Procédure : Supprime tous les emprunts
-- Appel exemple: CALL delete_emprunt_all() => Plus aucun emprunt

DELIMITER //
CREATE PROCEDURE delete_emprunt_all ()
BEGIN

DELETE FROM EMPRUNTS;

END //
DELIMITER ;


-- Prodécure : Supprime un emprunt spécifique
-- Appel exemple: CALL delete_emprunt_id(2); => L'emprunt avec l'ID 2 est supprimé

DELIMITER //
CREATE PROCEDURE delete_emprunt_id
(IN id INT )
BEGIN

DELETE FROM EMPRUNTS
WHERE ID_EMPRUNT=id;

END //
DELIMITER ;



