-- ============================================================
--    Mise à jour de la base
-- ============================================================

    -- ==============================
    --    Ajout d'un vélo 
    -- ==============================

DELIMITER //
CREATE PROCEDURE add_bike
(
    IN reference VARCHAR(20),
    IN marque VARCHAR(20), 
    IN date_service DATE,
    IN km INT,
    IN etat VARCHAR(10), 
    IN batterie INT,
    IN id_stat INT
)
BEGIN

DECLARE id INT; 
SELECT max(ID_VELO) from VELOS INTO id;
SET id = id + 1; 

insert into VELOS values (id, reference, marque, date_service, km, etat, batterie, id_stat);

END //
DELIMITER ;


DROP PROCEDURE add_bike;
CALL add_bike('test', "test", date('2021-11-08'), 0, 'NEUF', 100, 3);

    -- ==============================
    --    Ajout d'un trajet 
    -- ==============================

DELIMITER //
CREATE PROCEDURE add_journey
(
    IN date_debut DATE,
    IN heure_debut TIME, 
    IN station_debut INT,
    IN adherent INT,
    IN velo INT
)
BEGIN

DECLARE km INT; 
DECLARE id INT; 

SELECT max(ID_EMPRUNT) from EMPRUNTS INTO id;
SET id = id + 1;

SELECT KM_VELO from VELOS WHERE ID_VELO=velo INTO km;

insert into EMPRUNTS values (id, date_debut, heure_debut, km, station_debut, NULL, NULL, NULL, NULL, adherent, velo);
UPDATE VELOS SET ID_STATION = NULL WHERE ID_VELO=velo;


END //
DELIMITER ;

DROP PROCEDURE add_journey;
CALL add_journey(date('2021-11-15'), time('13:30:00'), 1, 4, 4);
    
    



    -- ==============================
    --    Suppression 
    -- ==============================


-- Prodécure : Supprime tout les adhérents et on met à jour les ID adhérents des emprunts

DELIMITER //
CREATE PROCEDURE delete_adherent_all()
BEGIN

SET foreign_key_checks = 0;
UPDATE EMPRUNTS SET ID_ADHERENT=-1;
DELETE FROM ADHERENTS; 
SET foreign_key_checks = 1;

END //
DELIMITER ;

-- Appel exemple: => Tous les utilisateurs sont supprimés et les emprunts mis à jour
CALL delete_adherent_all();


-- Prodécure : Supprime un adherent spécifique et on met à jour les ID adhérents des emprunts

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

-- Appel exemple:  => L'utilisateur 2 est supprimé et ses emprunts sont mis à jour
CALL delete_adherent_id(2);


-- Procédure : Supprime tous les emprunts
DELIMITER //
CREATE PROCEDURE delete_emprunt_all ()
BEGIN

DELETE FROM EMPRUNTS;

END //
DELIMITER ;

-- Appel exemple:  => Plus aucun emprunt
CALL delete_emprunt_all()


-- Prodécure : Supprime un emprunt spécifique

DELIMITER //
CREATE PROCEDURE delete_emprunt_id
(IN id INT )
BEGIN

DELETE FROM EMPRUNTS
WHERE ID_EMPRUNT=id;

END //
DELIMITER ;

-- Appel exemple:  => L'emprunt avec l'ID 2 est supprimé
CALL delete_emprunt_id(2);

