--  Dans ce fichier, on regroupe les appels aux procédures qui permettent la création/mise à jour/suppression dans les tables
--  L'implémentation de ces fonctions est dans le fichier creation_maj.sql



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

-- Appel exemple: => Fin de l'emprunt du vélo concernant l'emprunt 10
-- Le vélo est rendu le 2021-11-15 à 15:00:00 avec un kilométrage de 20 et dans la station n°6
-- Pour que cette requête d'exemple fonctionne: CALL ajout_emprunt(date('2021-11-15'), time('13:30:00'), 1, 2, 3);
CALL fin_emprunt(11, date('2021-11-15'), time('15:00:00'), 20, 6);

-- Appel exemple: => Actualise l'état du vélo 2 en "Mauvais"
CALL maj_velo_etat(2, 'MAUVAIS'); 

-- Appel exemple: => Actualise la batterie du vélo 1 à 50
CALL maj_velo_batterie(1, 50);

-- Appel exemple: => Actualise l'adresse de l'adhérent 3 par la valeur "ENSEIRB" et la commune 1
CALL maj_adherent_adresse(3, "ENSEIRB", 1);


-- ============================================================
--    Suppressions dans la base
-- ============================================================

---- Choix d'implémentations:
-- On ne peux pas supprimer un adhérent qui n'a pas encore rendu son vélo 
-- 

-- Appel exemple: => Tous les utilisateurs sont supprimés et les emprunts mis à jour
CALL supprimer_adherent_tous();

-- Appel exemple:  => L'utilisateur 2 est supprimé et ses emprunts sont mis à jour
CALL supprimer_adherent_id(2);

-- Appel exemple:  => Plus aucun emprunt
CALL supprimer_emprunt_tous();

-- Appel exemple:  => L'emprunt avec l'ID 2 est supprimé
CALL supprimer_emprunt_id(2);

-- Appel exemple: => Supprime le vélo 1 et tous ses trajets
CALL supprimer_velo_id(1);