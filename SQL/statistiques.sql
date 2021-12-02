-- ===============================================================================================================
--     Moyenne du nombre d’usagers par vélo par jour.
-- ===============================================================================================================
SELECT 
    ID_VELO, NOMBRE_UTILISATIONS / NOMBRE_JOUR AS MOYENNE
FROM 
    (SELECT 
        COUNT(*) AS NOMBRE_UTILISATIONS, ID_VELO
    FROM 
        EMPRUNTS
    GROUP BY 
        ID_VELO) AS UTILISATIONS_JOUR
JOIN 
    (SELECT 
        COUNT(*) AS NOMBRE_JOUR, ID_VELO
    FROM 
        (SELECT 
            ID_VELO, DATE_DEBUT_EMPRUNT 
        FROM 
            EMPRUNTS
        GROUP BY 
            ID_VELO, DATE_DEBUT_EMPRUNT) AS TEMP
    GROUP BY 
        ID_VELO) AS NOMBRE_JOURS
USING(ID_VELO)
GROUP BY 
    ID_VELO
;


-- ===============================================================================================================
--     Moyenne des distances parcourues par les vélos entre deux dates.
-- ===============================================================================================================
SELECT 
    SUM(DISTANCE) / COUNT(DISTINCT ID_VELO) AS MOYENNE_DES_DISTANCES
FROM
    (SELECT
            EMPRUNTS.ID_VELO, KM_FIN_EMPRUNT - KM_DEBUT_EMPRUNT AS DISTANCE
        FROM
            EMPRUNTS
        WHERE 
            ID_STATION_FIN IS NOT NULL AND EMPRUNTS.DATE_DEBUT_EMPRUNT >= DATE("2021-11-07") AND EMPRUNTS.DATE_FIN_EMPRUNT <= DATE("2021-11-15")) AS DISTANCES
;

-- ===============================================================================================================
--     Classement des stations par nombre de places disponibles décroissant par commune.
-- ===============================================================================================================
SELECT
    COMMUNES.NOM_COMMUNE, ID_STATION, TEMP.ADRESSE_STATION, NB_PLACES_DISPO
FROM
    COMMUNES
NATURAL JOIN
    (SELECT 
        STATIONS.*, STATIONS.NOMBRE_BORNES_STATION-NB_VELOS AS NB_PLACES_DISPO 
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
    USING(ID_STATION)) AS TEMP
ORDER BY COMMUNES.NOM_COMMUNE, NB_PLACES_DISPO DESC
;


-- ===============================================================================================================
--     Classement des vélos les plus chargés par station.
-- ===============================================================================================================
SELECT 
    VELOS.* 
FROM 
    VELOS 
WHERE 
    ID_STATION IS NOT NULL 
ORDER BY 
    ID_STATION ASC, BATTERIE_VELO DESC
;