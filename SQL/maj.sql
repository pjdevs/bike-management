
-- ============================================================
--    Ajouts dans la base
-- ============================================================

-- Appel exemple: => Création d'un vélo en station 5
CALL ajout_velo('Reference G2I2', "Marque ENSEIRB", date('2021-12-24'), 0, 'NEUF', 100, 5);

-- Appel exemple: => Emprunt le 2021-11-15 à 13:30:00 à la station 1 pour l'adherent 2 avec le velo 3
-- L'emprunt n'est pas terminé donc automatiquement le vélo est en cours d'utilisation (Pas de station)
CALL ajout_emprunt(date('2021-11-15'), time('13:30:00'), 1, 2, 3);
    
-- Appel exemple: => Création d'un adhérent dans la station 3
CALL ajout_adherent("GAUDY", "Antoine", 'ENSEIRB 33420 Talence', date('2021-12-01'), 3);

-- ============================================================
--    Mise à jour de la base
-- ============================================================

-- Appel exemple: => Fin de l'emprunt du vélo concernant l'emprunt 8
-- Le vélo est rendu le 2021-11-15 à 8:00:00 avec un kilométrage de 6 et dans la station n°6
CALL fin_emprunt(8, date('2021-11-15'), time('8:00:00'), 6, 6);

-- ============================================================
--    Suppressions
-- ============================================================

-- Appel exemple: => Tous les utilisateurs sont supprimés et les emprunts mis à jour
CALL delete_adherent_all();

-- Appel exemple:  => L'utilisateur 2 est supprimé et ses emprunts sont mis à jour
CALL delete_adherent_id(2);

-- Appel exemple:  => Plus aucun emprunt
CALL delete_emprunt_all()

-- Appel exemple:  => L'emprunt avec l'ID 2 est supprimé
CALL delete_emprunt_id(2);

