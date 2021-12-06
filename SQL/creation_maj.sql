--  Dans ce fichier, on regroupe les procédures qui permettent la création/mise à jour/suppression dans les tables
--  L'appel de ces fonctions est dans le fichier maj.sql


-- ============================================================
--    Ajouts dans la base
-- ============================================================


    -- ==============================
    --    Ajout d'un vélo 
    -- ==============================

DELIMITER //
CREATE OR REPLACE PROCEDURE ajout_velo
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
    SELECT MAX(ID_VELO) FROM VELOS INTO id;
    SET id = id + 1; 

    INSERT INTO VELOS VALUES (id, reference, marque, date_service, km, etat, batterie, id_stat);
END //
DELIMITER ;

    -- ==============================
    --    Ajout d'un trajet 
    -- ==============================

DELIMITER //
CREATE OR REPLACE PROCEDURE ajout_emprunt
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

    SELECT MAX(ID_EMPRUNT) from EMPRUNTS INTO id;
    SET id = id + 1;

    SELECT KM_VELO from VELOS WHERE ID_VELO=velo INTO km;

    UPDATE VELOS SET ID_STATION = NULL WHERE ID_VELO=velo;
    INSERT INTO EMPRUNTS VALUES (id, date_debut, heure_debut, km, station_debut, NULL, NULL, NULL, NULL, adherent, velo);
END //
DELIMITER ;


    -- ==============================
    --    Ajout d'un adhérent 
    -- ==============================

DELIMITER //
CREATE OR REPLACE PROCEDURE ajout_adherent
(
    IN nom VARCHAR(50),
    IN prenom VARCHAR(50), 
    IN adresse VARCHAR(100),
    IN date_adhesion DATE,
    IN commune INT
)
BEGIN
    DECLARE id INT; 
    SELECT MAX(ID_ADHERENT) FROm ADHERENTS INTO id;
    SET id = id + 1; 
    INSERT INTO ADHERENTS VALUES (id, nom, prenom, adresse, date_adhesion, commune);
END //
DELIMITER ;

-- ============================================================
--    Mise à jour de la base
-- ============================================================

    -- ==============================
    --    Mise à jour d'un emprunt
    -- ==============================

DELIMITER //
CREATE OR REPLACE PROCEDURE fin_emprunt
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
    UPDATE EMPRUNTS
    SET DATE_FIN_EMPRUNT = date_fin, HEURE_FIN_EMPRUNT = heure_fin, KM_FIN_EMPRUNT = km_fin, ID_STATION_FIN = station_fin
    WHERE ID_EMPRUNT=emprunt;
END //
DELIMITER ;

    -- ==============================
    --    Mise à jour d'un vélo
    -- ==============================

-- Prodécure : Met à jour l'état d'un vélo
DELIMITER //
CREATE OR REPLACE PROCEDURE maj_velo_etat(IN id INT, IN etat VARCHAR(10))
BEGIN

    UPDATE VELOS SET ETAT_VELO=etat WHERE ID_VELO=id;

END //
DELIMITER ;

-- Prodécure : Met à jour la batterie d'un vélo
DELIMITER //
CREATE OR REPLACE PROCEDURE maj_velo_batterie(IN id INT, IN batterie INT)
BEGIN

    UPDATE VELOS SET BATTERIE_VELO=batterie WHERE ID_VELO=id;

END //
DELIMITER ;

    -- ==============================
    --    Mise à jour d'un adhérent
    -- ==============================

-- Prodécure : Met à jour l'adresse & commune d'un adhérent
DELIMITER //
CREATE OR REPLACE PROCEDURE maj_adherent_adresse(IN id INT, IN adresse VARCHAR(100), IN commune INT)
BEGIN

    UPDATE ADHERENTS SET ADRESSE_ADHERENT=adresse, ID_COMMUNE=commune WHERE ID_ADHERENT=id;

END //
DELIMITER ;


-- ============================================================
--    Suppressions
-- ============================================================


    -- ==============================
    --    Suppression d'adhérents
    -- ==============================


-- Prodécure : Supprime tout les adhérents et on met à jour l'ID adhérent de tous les emprunts
DELIMITER //
CREATE OR REPLACE PROCEDURE supprimer_adherent_tous()
BEGIN
    UPDATE EMPRUNTS SET ID_ADHERENT=-1;
    DELETE FROM ADHERENTS WHERE ID_ADHERENT>0;
END //
DELIMITER ;

-- Prodécure : Supprime un adherent spécifique et on met à jour l'ID adhérent des emprunts de l'adhérent
DELIMITER //
CREATE OR REPLACE PROCEDURE supprimer_adherent_id
(IN id INT)
BEGIN
        UPDATE EMPRUNTS SET ID_ADHERENT=-1 WHERE ID_ADHERENT=id;
        DELETE FROM ADHERENTS WHERE ID_ADHERENT=id AND id>0; 
END //
DELIMITER ;


    -- ==============================
    --    Suppression d'emprunts
    -- ==============================

-- Procédure : Supprime tous les emprunts
DELIMITER //
CREATE OR REPLACE PROCEDURE supprimer_emprunt_tous()
BEGIN
    DELETE FROM EMPRUNTS;
END //
DELIMITER ;

-- Prodécure : Supprime un emprunt spécifique
DELIMITER //
CREATE OR REPLACE PROCEDURE supprimer_emprunt_id
(IN id INT)
BEGIN
    DELETE FROM EMPRUNTS WHERE ID_EMPRUNT=id;
END //
DELIMITER ;


    -- ==============================
    --    Suppression de vélos
    -- ==============================

-- Prodécure : Supprime un vélo spécifique et tous les emprunts effectués avec ce vélo
DELIMITER //
CREATE OR REPLACE PROCEDURE supprimer_velo_id
(IN id INT)
BEGIN

    DELETE FROM EMPRUNTS WHERE ID_VELO=id;
    DELETE FROM VELOS WHERE ID_VELO=id;
END //
DELIMITER ;