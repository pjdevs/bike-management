-- ============================================================
--    Supression des procédures
-- ============================================================

DROP PROCEDURE IF EXISTS ajout_velo;
DROP PROCEDURE IF EXISTS ajout_emprunt;
DROP PROCEDURE IF EXISTS ajout_adherent;
DROP PROCEDURE IF EXISTS fin_emprunt;
DROP PROCEDURE IF EXISTS maj_velo_etat;
DROP PROCEDURE IF EXISTS maj_velo_batterie;
DROP PROCEDURE IF EXISTS maj_adherent_adresse;
DROP PROCEDURE IF EXISTS supprimer_adherent_tous;
DROP PROCEDURE IF EXISTS supprimer_adherent_id;
DROP PROCEDURE IF EXISTS supprimer_emprunt_tous;
DROP PROCEDURE IF EXISTS supprimer_emprunt_id;
DROP PROCEDURE IF EXISTS supprimer_velo_id;

-- ============================================================
--    Supression des triggers
-- ============================================================

DROP TRIGGER IF EXISTS VELO_PAS_LA;
DROP TRIGGER IF EXISTS TROP_DE_VELO;
DROP TRIGGER IF EXISTS KM_EMPRUNT_DIFFERENT;
DROP TRIGGER IF EXISTS DIMINUER_KM_VELO;
DROP TRIGGER IF EXISTS CHAMPS_ENCORE_NULL;
DROP TRIGGER IF EXISTS ADHERENT_PAS_RENDU;
DROP TRIGGER IF EXISTS EMPRUNT_AVANT_DATE;
DROP TRIGGER IF EXISTS RENDU_AVANT_EMPRUNT;
DROP TRIGGER IF EXISTS DEJA_EMPRUNT;
DROP TRIGGER IF EXISTS VELO_ENCORE_DANS_STATION;

-- ============================================================
--    Supression des vues
-- ============================================================

DROP VIEW IF EXISTS EMPRUNTS_DATES_MAX;
DROP VIEW IF EXISTS DERNIER_EMPRUNT_ADHERENT;
DROP VIEW IF EXISTS NB_PLACES_DISPO_STATION;

-- ============================================================
--    Supression des tables
-- ============================================================

DROP TABLE IF EXISTS DISTANCIER;
DROP TABLE IF EXISTS EMPRUNTS;
DROP TABLE IF EXISTS VELOS;
DROP TABLE IF EXISTS ADHERENTS;
DROP TABLE IF EXISTS STATIONS;
DROP TABLE IF EXISTS COMMUNES;

