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
--    Contraintes d'intégrité supplémentaires
-- ============================================================

-- On fait l'hypothèse que pour rendre un vélo on a ce processus :
--    1. On stocke le vélo (colonne STATION de VELOS)
--    2. On remplit l'emprunt (colonnes *_FIN)


-- On emprunte un vélo à une station alors qu'il n'y est pas

-- Rend un vélo à une station alors qu'elle n'a pa assez de bornes
DELIMITER //

CREATE OR REPLACE TRIGGER TROP_DE_VELO
AFTER UPDATE ON EMPRUNTS FOR EACH ROW
BEGIN
    IF (select count(*) from VELOS where VELOS.ID_STATION = NEW.ID_STATION_FIN) > (select NOMBRE_BORNES_STATION from STATIONS where ID_STATION = NEW.ID_STATION_FIN) THEN
        update EMPRUNTS set ID_STATION_FIN = NULL where ID_EMPRUNT = NEW.ID_EMPRUNT;
        update EMPRUNTS set DATE_FIN_EMPRUNT = NULL where ID_EMPRUNT = NEW.ID_EMPRUNT;
        update EMPRUNTS set HEURE_FIN_EMPRUNT = NULL where ID_EMPRUNT = NEW.ID_EMPRUNT;
        update EMPRUNTS set KM_FIN_EMPRUNT = NULL where ID_EMPRUNT = NEW.ID_EMPRUNT;
        -- TODO: Lancer une erreur
    END IF;
END; //

DELIMITER ;

-- On emprunte un vélo avec un KM_DEBUT différent du KM_VELO du vélo

-- On emprunte un vélo qui est déjà emprunté