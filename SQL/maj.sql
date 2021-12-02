-- ============================================================
--    Ajouts dans la base
-- ============================================================

    -- ==============================
    --    Ajout d'un vélo 
    -- ==============================

DELIMITER //
CREATE PROCEDURE ajout_velo
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


DROP PROCEDURE ajout_velo;
CALL ajout_velo('test', "test", date('2021-11-08'), 0, 'NEUF', 100, 3);

    -- ==============================
    --    Ajout d'un trajet 
    -- ==============================

DELIMITER //
CREATE PROCEDURE ajout_emprunt
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

DROP PROCEDURE ajout_emprunt;
CALL ajout_emprunt(date('2021-11-15'), time('13:30:00'), 1, 4, 4);
    

    -- ==============================
    --    Ajout d'un adhérent 
    -- ==============================

DELIMITER //
CREATE PROCEDURE ajout_adherent
(
    IN nom VARCHAR(50),
    IN prenom VARCHAR(50), 
    IN adresse VARCHAR(100),
    IN date_adhesion DATE,
    IN commune INT
)
BEGIN

DECLARE id INT; 
SELECT max(ID_ADHERENT) from ADHERENTS INTO id;
SET id = id + 1; 

insert into ADHERENTS values (id, nom, prenom, adresse, date_adhesion, commune);

END //
DELIMITER ;


CALL ajout_adherent("GAUDY", "Antoine", 'Perdu dans le fossé', date('2021-12-01'), 5);


-- ============================================================
--    Mise à jour de la base
-- ============================================================

    -- ==============================
    --    Mise à jour d'un emprunt
    -- ==============================

DELIMITER //
CREATE PROCEDURE fin_emprunt
(
    IN emprunt INT,
    IN date_fin DATE,
    IN heure_fin TIME, 
    IN km_fin INT,
    IN station_fin INT
)
BEGIN

DECLARE velo INT; 
SELECT ID_VELO from EMPRUNTS WHERE ID_EMPRUNT = emprunt INTO velo; 
UPDATE VELOS SET ID_STATION = station_fin, KM_VELO = km_fin WHERE ID_VELO = velo;

UPDATE EMPRUNTS SET DATE_FIN_EMPRUNT = date_fin, HEURE_FIN_EMPRUNT = heure_fin, KM_FIN_EMPRUNT = km_fin, ID_STATION_FIN = station_fin WHERE ID_EMPRUNT=emprunt;

END //
DELIMITER ;

CALL fin_emprunt(9, date('2021-11-15'), time('13:50:00'), 5, 5);

-- ============================================================
--    Suppressions
-- ============================================================


    -- ==============================
    --    Suppression d'adhérents
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


    -- ==============================
    --    Suppression d'emprunts
    -- ==============================

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

