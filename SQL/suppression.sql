-- ============================================================
--    Supression des triggers
-- ============================================================

DROP TRIGGER IF EXISTS `VELO_PAS_LA`
DROP TRIGGER IF EXISTS `TROP_DE_VELO`
DROP TRIGGER IF EXISTS `KM_EMPRUNT_DIFFERENT`
DROP TRIGGER IF EXISTS `DIMINUER_KM_VELO`

-- ============================================================
--    Supression des tables
-- ============================================================

DROP TABLE IF EXISTS `DISTANCIER`;
DROP TABLE IF EXISTS `EMPRUNTS`;
DROP TABLE IF EXISTS `VELOS`;
DROP TABLE IF EXISTS `ADHERENTS`;
DROP TABLE IF EXISTS `STATIONS`;
DROP TABLE IF EXISTS `COMMUNES`;

-- ============================================================
--    Suppression des tables
-- ============================================================
-- DROP DATABASE `VELO`;
