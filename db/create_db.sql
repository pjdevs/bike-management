CREATE TABLE COMMUNES(
    ID_COMMUNE COUNTER NOT NULL,
    NOM_COMMUNE VARCHAR(50) NOT NULL,
    PRIMARY KEY(ID_COMMUNE)
);

CREATE TABLE STATIONS(
    ID_STATION COUNTER NOT NULL,
    ADRESSE_STATION VARCHAR(50) NOT NULL,
    NOMBRE_BORNES_STATION INT NOT NULL,
    ID_COMMUNE INT NOT NULL,
    PRIMARY KEY(ID_STATION),
    FOREIGN KEY(ID_COMMUNE) REFERENCES COMMUNES(ID_COMMUNE)
);

CREATE TABLE ADHERENTS(
    ID_ADHERENT COUNTER NOT NULL,
    NOM_ADHERENT VARCHAR(50) NOT NULL,
    PRENOM_ADHERENT VARCHAR(50) NOT NULL,
    ADRESSE_ADHERENT VARCHAR(50) NOT NULL,
    DATE_ADHESION_ADHERENT DATE NOT NULL,
    ID_COMMUNE INT NOT NULL,
    PRIMARY KEY(ID_ADHERENT),
    FOREIGN KEY(ID_COMMUNE) REFERENCES COMMUNES(ID_COMMUNE)
);

CREATE TABLE VELOS(
    ID_VELO COUNTER NOT NULL,
    REFERENCE_VELO VARCHAR(20) NOT NULL,
    MARQUE_VELO VARCHAR(20) NOT NULL,
    DATE_SERVICE_VELO DATE NOT NULL,
    KM_VELO INT NOT NULL,
    ETAT_VELO VARCHAR(10) NOT NULL,
    BATTERIE_VELO INT NOT NULL,
    ID_STATION INT,
    PRIMARY KEY(ID_VELO),
    FOREIGN KEY(ID_STATION) REFERENCES STATIONS(ID_STATION)
);

CREATE TABLE EMPRUNTS(
    ID_EMPRUNT COUNTER NOT NULL,
    DATE_DEBUT_EMPRUNT DATE NOT NULL,
    HEURE_DEBUT_EMPRUNT TIME NOT NULL,
    KM_DEBUT_EMPRUNT INT NOT NULL,
    DATE_FIN_EMPRUNT DATE,
    HEURE_FIN_EMPRUNT TIME,
    KM_FIN_EMPRUNT INT,
    ID_STATION_DEBUT INT NOT NULL,
    ID_STATION_FIN INT,
    ID_ADHERENT INT NOT NULL,
    ID_VELO INT NOT NULL,
    PRIMARY KEY(ID_EMPRUNT),
    FOREIGN KEY(ID_STATION_DEBUT) REFERENCES STATIONS(ID_STATION),
    FOREIGN KEY(ID_STATION_FIN) REFERENCES STATIONS(ID_STATION),
    FOREIGN KEY(ID_ADHERENT) REFERENCES ADHERENTS(ID_ADHERENT),
    FOREIGN KEY(ID_VELO) REFERENCES VELOS(ID_VELO)
);

CREATE TABLE DISTANCIER(
    ID_STATION_1 INT NOT NULL,
    ID_STATION_2 INT NOT NULL,
    DISTANCE_STATION INT NOT NULL,
    PRIMARY KEY(ID_STATION_1, ID_STATION_2),
    FOREIGN KEY(ID_STATION_1) REFERENCES STATIONS(ID_STATION),
    FOREIGN KEY(ID_STATION_2) REFERENCES STATIONS(ID_STATION)
);
