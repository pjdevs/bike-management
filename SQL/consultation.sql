-- ========================================================================================================================
--     Informations sur les vélos, les stations, les adhérents.
-- ========================================================================================================================
SELECT * FROM VELOS;
SELECT * FROM STATIONS;
SELECT * FROM ADHERENTS;


-- ========================================================================================================================
--     Liste des vélos par station.
-- ========================================================================================================================
SELECT 
    * 
FROM 
    VELOS 
WHERE 
    ID_STATION IS NOT NULL 
ORDER BY 
    ID_STATION;


-- ========================================================================================================================
--     La liste des vélos en cours d’utilisation.
-- ========================================================================================================================
SELECT 
    * 
FROM 
    VELOS 
WHERE 
    ID_STATION IS NULL;


-- ========================================================================================================================
--     Liste des stations dans une commune donnée (ici la commune 2)
-- ========================================================================================================================
SELECT 
    * 
FROM 
    STATIONS
WHERE 
    ID_COMMUNE=2;


-- ========================================================================================================================
--     Liste des adhérents qui ont emprunté au moins deux vélos différents pour un jour donné (ici le 08/11/2021)
-- ========================================================================================================================
SELECT 
    * 
FROM 
    (SELECT 
        ADHERENTS.*
    FROM 
        ADHERENTS 
    JOIN 
        EMPRUNTS 
    USING(ID_ADHERENT) 
    WHERE 
        DATE_DEBUT_EMPRUNT=date('2021-11-08') 
    GROUP BY 
    ADHERENTS.ID_ADHERENT, EMPRUNTS.ID_VELO) AS TEMP 
GROUP BY 
    ID_ADHERENT 
HAVING 
    COUNT(*)>=2;

-- ========================================================================================================================
--     Liste des vélos qui ont été emprunté au moins deux fois pour un jour donné (ici le 08/11/2021)
-- ========================================================================================================================

SELECT 
    *
FROM 
    (SELECT
        VELOS.*
    FROM 
        VELOS 
    JOIN
        EMPRUNTS
    USING(ID_VELO)
    WHERE 
        DATE_DEBUT_EMPRUNT=date('2021-11-08')
    GROUP BY 
        VELOS.ID_VELO, EMPRUNTS.ID_EMPRUNT) AS TEMP
GROUP BY    
    ID_VELO
HAVING 
    COUNT(*)>=2;



-- ========================================================================================================================
--     Le nombre de places disponicles par station.
-- ========================================================================================================================
SELECT 
        STATIONS.ID_STATION, STATIONS.ADRESSE_STATION, STATIONS.NOMBRE_BORNES_STATION-NB_VELOS AS NB_PLACES_DISPO 
    FROM
        STATIONS 
    JOIN 
        (SELECT 
            ID_STATION, COUNT(*) AS NB_VELOS 
        FROM 
            VELOS 
        GROUP BY 
            ID_STATION 
        HAVING 
            ID_STATION IS NOT NULL) AS NB_VELOS_STATIONS
    USING(ID_STATION)
;