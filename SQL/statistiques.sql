-- ===========================================================================
--     Moyenne du nombre d’usagers par vélo par jour.
-- ===========================================================================
SELECT COUNT(ID_VELO) AS MOYENNE 
    FROM (SELECT ID_VELO, DATE_DEBUT_EMPRUNT 
        FROM EMPRUNTS 
        GROUP BY ID_VELO, DATE_DEBUT_EMPRUNT)
    

-- ===========================================================================
--     Moyenne des distances parcourues par les vélos sur une semaine.
-- ===========================================================================

-- ===========================================================================
--     Classement des stations par nombre de places disponibles par commune.
-- ===========================================================================

-- ===========================================================================
--     Classement des vélos les plus chargés par station.
-- ===========================================================================