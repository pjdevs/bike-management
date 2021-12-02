-- ============================================================
--    Suppression des tables
-- ============================================================

DROP TABLE IF EXISTS `DISTANCIER`;
DROP TABLE IF EXISTS `EMPRUNTS`;
DROP TABLE IF EXISTS `VELOS`;
DROP TABLE IF EXISTS `ADHERENTS`;
DROP TABLE IF EXISTS `STATIONS`;
DROP TABLE IF EXISTS `COMMUNES`;

-- ============================================================
--    Création des tables
-- ============================================================

CREATE TABLE COMMUNES(
    ID_COMMUNE INT NOT NULL UNIQUE AUTO_INCREMENT,
    NOM_COMMUNE VARCHAR(50) NOT NULL,
    PRIMARY KEY(ID_COMMUNE)
);

CREATE TABLE STATIONS(
    ID_STATION INT NOT NULL UNIQUE AUTO_INCREMENT,
    ADRESSE_STATION VARCHAR(100) NOT NULL,
    NOMBRE_BORNES_STATION INT NOT NULL CHECK(NOMBRE_BORNES_STATION > 0),
    ID_COMMUNE INT NOT NULL,
    LATTITUDE_STATION DOUBLE NOT NULL,
    LONGITUDE_STATION DOUBLE NOT NULL,
    PRIMARY KEY(ID_STATION),
    FOREIGN KEY(ID_COMMUNE) REFERENCES COMMUNES(ID_COMMUNE)
);

CREATE TABLE ADHERENTS(
    ID_ADHERENT INT NOT NULL UNIQUE AUTO_INCREMENT,
    NOM_ADHERENT VARCHAR(50) NOT NULL,
    PRENOM_ADHERENT VARCHAR(50) NOT NULL,
    ADRESSE_ADHERENT VARCHAR(100) NOT NULL,
    DATE_ADHESION_ADHERENT DATE NOT NULL,
    ID_COMMUNE INT NOT NULL,
    PRIMARY KEY(ID_ADHERENT),
    FOREIGN KEY(ID_COMMUNE) REFERENCES COMMUNES(ID_COMMUNE)
);

CREATE TABLE VELOS(
    ID_VELO INT NOT NULL UNIQUE AUTO_INCREMENT,
    REFERENCE_VELO VARCHAR(20) NOT NULL,
    MARQUE_VELO VARCHAR(20) NOT NULL,
    DATE_SERVICE_VELO DATE NOT NULL,
    KM_VELO INT NOT NULL CHECK (KM_VELO >= 0),
    ETAT_VELO VARCHAR(10) NOT NULL CHECK(ETAT_VELO IN ('NEUF', 'BON', 'MOYEN', 'MAUVAIS')),
    BATTERIE_VELO INT NOT NULL CHECK(BATTERIE_VELO >= 0 AND BATTERIE_VELO <= 100),
    ID_STATION INT,
    PRIMARY KEY(ID_VELO),
    FOREIGN KEY(ID_STATION) REFERENCES STATIONS(ID_STATION)
);

CREATE TABLE EMPRUNTS(
    ID_EMPRUNT INT NOT NULL UNIQUE AUTO_INCREMENT,
    DATE_DEBUT_EMPRUNT DATE NOT NULL,
    HEURE_DEBUT_EMPRUNT TIME NOT NULL,
    KM_DEBUT_EMPRUNT INT NOT NULL,
    ID_STATION_DEBUT INT NOT NULL,
    DATE_FIN_EMPRUNT DATE,
    HEURE_FIN_EMPRUNT TIME,
    KM_FIN_EMPRUNT INT,
    ID_STATION_FIN INT,
    ID_ADHERENT INT NOT NULL,
    ID_VELO INT NOT NULL,
    CHECK(DATE_DEBUT_EMPRUNT <= DATE_FIN_EMPRUNT),
    CHECK(KM_DEBUT_EMPRUNT <= KM_FIN_EMPRUNT),
    PRIMARY KEY(ID_EMPRUNT),
    FOREIGN KEY(ID_STATION_DEBUT) REFERENCES STATIONS(ID_STATION),
    FOREIGN KEY(ID_STATION_FIN) REFERENCES STATIONS(ID_STATION),
    FOREIGN KEY(ID_ADHERENT) REFERENCES ADHERENTS(ID_ADHERENT),
    FOREIGN KEY(ID_VELO) REFERENCES VELOS(ID_VELO)
);

CREATE TABLE DISTANCIER(
    ID_STATION_1 INT NOT NULL,
    ID_STATION_2 INT NOT NULL,
    DISTANCE_STATION INT NOT NULL CHECK (DISTANCE_STATION > 0),
    PRIMARY KEY(ID_STATION_1, ID_STATION_2),
    FOREIGN KEY(ID_STATION_1) REFERENCES STATIONS(ID_STATION),
    FOREIGN KEY(ID_STATION_2) REFERENCES STATIONS(ID_STATION)
);

-- ============================================================
--    Vues utiles
-- ============================================================

-- Vue d'aide pour récupérer le dernier emprunt d'un adhérent
CREATE OR REPLACE VIEW EMPRUNTS_DATES_MAX
AS
    SELECT 
        E.ID_ADHERENT, E.ID_EMPRUNT, E.HEURE_DEBUT_EMPRUNT
    FROM
        EMPRUNTS E
    NATURAL JOIN
        (SELECT
            ID_ADHERENT, MAX(DATE_DEBUT_EMPRUNT) DATE_DEBUT_EMPRUNT
        FROM
            EMPRUNTS
        GROUP BY
            ID_ADHERENT) AS TEMP

-- Vue sur le dernier emprunt d'un adhérent
CREATE OR REPLACE VIEW DERNIER_EMPRUNT_ADHERENT
AS
    SELECT
        ID_ADHERENT, ID_EMPRUNT
    FROM
        EMPRUNTS_DATES_MAX
    NATURAL JOIN
        (SELECT
            ID_ADHERENT, MAX(HEURE_DEBUT_EMPRUNT) HEURE_DEBUT_EMPRUNT
        FROM
            EMPRUNTS_DATES_MAX
        GROUP BY
            ID_ADHERENT) AS EMPRUNTS_HEURES_MAX
;

-- ============================================================
--    Fonctions utiles
-- ============================================================

-- Prédit si un adhérent est actuellement en train d'emprunter un vélo
-- BUG à résoudre
-- CREATE OR REPLACE FUNCTION adherent_est_sur_velo(id_adherent INT) RETURNS BOOLEAN
-- RETURN
--     (SELECT
--         ID_STATION_FIN IS NULL
--     FROM
--         EMPRUNTS
--     WHERE
--         ID_EMPRUNT = (SELECT
--                         ID_EMPRUNT
--                       FROM
--                           DERNIER_EMPRUNT_ADHERENT
--                       WHERE
--                           ID_ADHERENT = id_adherent)
--     )
-- ;

DELIMITER //

-- ============================================================
--    Contraintes d'intégrité supplémentaires
-- ============================================================

-- On fait l'hypothèse que pour rendre un vélo on a ce processus :
--    1. On stocke le vélo (colonne ID_STATION de VELOS)
--    2. On remplit l'emprunt (colonnes *_FIN)

-- Les colonnes *_FIN doivent toutes être remplies si une seule est remplie
--    i.e on doit remplir toutes les *_FIN quand on rend un vélo

CREATE OR REPLACE TRIGGER CHAMPS_ENCORE_NULL
BEFORE UPDATE ON EMPRUNTS FOR EACH ROW
BEGIN
    IF NEW.ID_STATION IS NOT NULL OR NEW.DATE_FIN_EMPRUNT IS NOT NULL OR NEW.HEURE_FIN_EMPRUNT IS NOT NULL OR NEW.KM_FIN_EMPRUNT IS NOT NULL THEN
        IF NEW.ID_STATION IS NULL OR NEW.DATE_FIN_EMPRUNT IS NULL OR NEW.HEURE_FIN_EMPRUNT IS NULL OR NEW.KM_FIN_EMPRUNT IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Certains champs FIN sont toujours NULL';
        END IF;
    END IF;
END; //

-- Le velo n'a pas été affecté, avant, à la station de fin de l'emprunt
CREATE OR REPLACE TRIGGER VELO_MAUVAISE_STATION
BEFORE UPDATE ON EMPRUNTS FOR EACH ROW
BEGIN
    IF NEW.ID_STATION IS NOT NULL THEN
        DECLARE station_velo INT;

        SELECT ID_STATION FROM VELOS WHERE VELOS.ID_VELO = NEW.ID_VELO INTO station_velo;

        IF station_velo <> NEW.ID_STATION_FIN THEN
            SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Le vélo n a pas été rendu dans la station de fin désignée';
        END IF;
    END IF;
END; //

-- Supprimer un adhérent alors qu'il est en train d'emprunter un vélo
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER ADHERENT_PAS_RENDU
-- BEFORE DELETE ON ADHERENTS FOR EACH ROW
-- BEGIN
--     -- Verifier il n'a aucun emprunt en cours
-- END; //

-- DELIMITER ;

-- On emprunte un vélo à une station alors qu'il n'y est pas
CREATE OR REPLACE TRIGGER VELO_PAS_LA
BEFORE INSERT ON EMPRUNTS FOR EACH ROW
BEGIN
    DECLARE velo_est_dans_station INT;

    SELECT count(*) FROM VELOS WHERE VELOS.ID_VELO = NEW.ID_VELO INTO velo_est_dans_station;

    IF velo_est_dans_station <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Impossible d emprunter ce vélo, il n est pas dans cette station';
    END IF;
END; //

-- Rend un vélo à une station alors qu'elle n'a pa assez de bornes
CREATE OR REPLACE TRIGGER TROP_DE_VELO
BEFORE UPDATE ON EMPRUNTS FOR EACH ROW
BEGIN
    DECLARE nb_velos_station INT;
    DECLARE nb_bornes INT;

    SELECT count(*) FROM VELOS WHERE VELOS.ID_STATION = NEW.ID_STATION_FIN INTO nb_velos_station;
    SELECT NOMBRE_BORNES_STATION FROM STATIONS WHERE ID_STATION = NEW.ID_STATION_FIN INTO nb_bornes;

    IF nb_velos_station >= nb_bornes THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Pas assez de bornes à cette station, elle est pleine';
    END IF;
END; //

-- On emprunte un vélo avec un KM_DEBUT différent du KM_VELO du vélo
CREATE OR REPLACE TRIGGER KM_EMPRUNT_DIFFERENT
BEFORE INSERT ON EMPRUNTS FOR EACH ROW
BEGIN
    DECLARE nb_km_velo INT;

    SELECT KM_VELO FROM VELOS WHERE VELOS.ID_VELO = NEW.ID_VELO INTO nb_km_velo;

    IF nb_km_velo != NEW.KM_DEBUT_EMPRUNT THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Le kilométrage du début de l emprunt ne correspond au kilométrage';
    END IF;
END; //

-- Empruntez un vélo avant qu'il ai été mis en service
CREATE OR REPLACE TRIGGER EMPRUNT_AVANT_DATE
BEFORE INSERT ON EMPRUNTS FOR EACH ROW
BEGIN
    DECLARE date_service_velo DATE;
    
    SELECT DATE_SERVICE_VELO FROM VELOS WHERE VELOS.ID_VELO = NEW.ID_VELO INTO date_service_velo;

    IF NEW.DATE_DEBUT_EMPRUNT < date_service_velo THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Un vélo ne peut pas être emprunté à une date inférieure à sa date de mise en service';
    END IF;
END; //

-- Rendre un vélo avant la date d'emprunt
-- TODO

-- Emprunter un vélo par un adhérent qui est déjà sur un vélo
CREATE OR REPLACE TRIGGER DEJA_EMPRUNT
BEFORE INSERT ON EMPRUNTS FOR EACH ROW
BEGIN
    DECLARE est_sur_velo BOOLEAN;

    SELECT
        ID_STATION_FIN IS NULL
    FROM
        EMPRUNTS
    WHERE
        ID_EMPRUNT = (SELECT
                        ID_EMPRUNT
                      FROM
                          DERNIER_EMPRUNT_ADHERENT
                      WHERE
                          ID_ADHERENT = NEW.ID_ADHERENT)
    INTO
        est_sur_velo;

    IF est_sur_velo THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Un vélo ne peut pas être emprunté par un adhérent déjà sur un vélo';
    END IF;

END; //

-- Vérifier station nulle au moment de l'emprunt 
-- TODO

-- Diminuer les kilomètres d'un vélo
CREATE OR REPLACE TRIGGER DIMINUER_KM_VELO
BEFORE UPDATE ON VELOS FOR EACH ROW
BEGIN
    DECLARE nb_km_velo INT;

    SELECT KM_VELO FROM VELOS WHERE VELOS.ID_VELO = NEW.ID_VELO INTO nb_km_velo;

    IF NEW.KM_VELO < nb_km_velo THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Un vélo ne peut pas perdre de kilométrage';
    END IF;
END; //


-- ============================================================
--    Ajouts dans la base
-- ============================================================


    -- ==============================
    --    Ajout d'un vélo 
    -- ==============================

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

    -- ==============================
    --    Ajout d'un trajet 
    -- ==============================

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

    SELECT max(ID_EMPRUNT) from EMPRUNTS INTO id;
    SET id = id + 1;

    SELECT KM_VELO from VELOS WHERE ID_VELO=velo INTO km;

    INSERT INTO EMPRUNTS VALUES (id, date_debut, heure_debut, km, station_debut, NULL, NULL, NULL, NULL, adherent, velo);
    UPDATE VELOS SET ID_STATION = NULL WHERE ID_VELO=velo;
END //


    -- ==============================
    --    Ajout d'un adhérent 
    -- ==============================

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

-- ============================================================
--    Mise à jour de la base
-- ============================================================

    -- ==============================
    --    Mise à jour d'un emprunt
    -- ==============================

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

-- ============================================================
--    Suppressions
-- ============================================================


    -- ==============================
    --    Suppression d'adhérents
    -- ==============================


-- Prodécure : Supprime tout les adhérents et on met à jour l'ID adhérent de tous les emprunts
CREATE OR REPLACE PROCEDURE supprimer_adherent_all()
BEGIN

SET foreign_key_checks = 0;
UPDATE EMPRUNTS SET ID_ADHERENT=-1;
DELETE FROM ADHERENTS; 
SET foreign_key_checks = 1;

END //

-- Prodécure : Supprime un adherent spécifique et on met à jour l'ID adhérent des emprunts de l'adhérent
CREATE OR REPLACE PROCEDURE supprimer_adherent_id
(IN id INT)
BEGIN
    SET foreign_key_checks = 0;
    UPDATE EMPRUNTS SET ID_ADHERENT=-1 WHERE ID_ADHERENT=id;
    DELETE FROM ADHERENTS WHERE ID_ADHERENT=id; 
    SET foreign_key_checks = 1;
END //


    -- ==============================
    --    Suppression d'emprunts
    -- ==============================

-- Procédure : Supprime tous les emprunts
CREATE OR REPLACE PROCEDURE supprimer_emprunt_tous()
BEGIN
    DELETE FROM EMPRUNTS;
END //

-- Prodécure : Supprime un emprunt spécifique
CREATE OR REPLACE PROCEDURE supprimer_emprunt_id
(IN id INT)
BEGIN
    DELETE FROM EMPRUNTS WHERE ID_EMPRUNT=id;
END //

    -- ==============================
    --    Suppression de vélos
    -- ==============================

DELIMITER ;