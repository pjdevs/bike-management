-- ============================================================
--    suppression des donnees
-- ============================================================

delete from EMPRUNTS;
delete from ADHERENTS;
delete from VELOS;
delete from STATIONS;
delete from COMMUNES;

commit;

-- ============================================================
--    creation des donnees
-- ============================================================

-- COMMUNES

insert into COMMUNES values (1, 'Bordeaux');
insert into COMMUNES values (2, 'Pessac'); 
insert into COMMUNES values (3, 'Talence'); 
insert into COMMUNES values (4, 'Mérignac'); 
insert into COMMUNES values (5, 'Pau'); 

commit;

-- STATIONS

insert into STATIONS values (1, '1 Avenue du Docteur Albert Schweitzer, 33400 Talence', 1, 3, 44.792864, -0.623373);
insert into STATIONS values (2, 'Place Pey Berland 33000, Bordeaux', 5, 1, 44.83772845,-0.5765286471688031); 
insert into STATIONS values (3, '42 rue Marc Sangnier 33400 Talence', 25, 3, 44.8084094, -0.6037152);
insert into STATIONS values (4, '12 Rue Camille Pelletan 33400 Talence', 50, 3, 44.8128305, -0.5909929); 
insert into STATIONS values (5, 'Avenue René Cassin 33700 Mérignac', 200, 4, 44.8332441, -0.686935); 
insert into STATIONS values (6, '4 Bis Rue Antoine Becquerel 33600 Pessac', 35, 2, 44.7904825,-0.6504596); 

commit;

-- VELOS


insert into VELOS values (1, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 0, 'NEUF', 100, 1);
insert into VELOS values (2, 'ELOPS 920', "ELOPS", date('2021-10-08'), 45, 'BON', 70, 2); 
insert into VELOS values (3, 'XC 100 S', "ROCK RIDER", date('2021-11-01'), 5, 'NEUF', 100, 2);
insert into VELOS values (4, 'RIVERSIDE 500', "RIVERSIDE", date('2021-11-01'), 100, 'MOYEN', 50, 3); 
insert into VELOS values (5, 'RIVERSIDE 920 E', "RIVERSIDE", date('2021-11-01'), 90, 'BON', 60, 3);
insert into VELOS values (6, 'ELOPS 120 E', "ELOPS", date('2021-11-05'), 765, 'MAUVAIS', 20, 4); 
insert into VELOS values (7, 'ELOPS 900 E', "ELOPS", date('2021-11-05'), 220, 'MOYEN', 70, 4); 
insert into VELOS values (8, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 20, 'NEUF', 80, 5);
insert into VELOS values (9, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 107, 'MOYEN', 50, 5);
insert into VELOS values (10, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 112, 'MOYEN', 44, 5);
insert into VELOS values (11, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 0, 'NEUF', 90, 5);
insert into VELOS values (12, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 50, 'NEUF', 60, 5);
insert into VELOS values (13, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 100, 'BON', 40, 5);
insert into VELOS values (14, 'E-ST 24', "STILUS", date('2021-11-28'), 70, 'MOYEN', 12, 6); 
insert into VELOS values (15, 'E-ST 29', "STILUS", date('2021-12-02'), 35, 'BON', 70, 6);

commit;

-- ADHERENTS

insert into ADHERENTS values (-1, 'Ancien', 'Utilisateur', 'X', date('2000-00-00'), 1);
insert into ADHERENTS values (1, 'MOREL', 'Pierre-Jean', '7 Rue Salvador Allende, 33400 Talence', date('2021-11-08'), 3);
insert into ADHERENTS values (2, 'MARAIS', 'Lucas', '14 Rue Léo Ferré 33400 Pessac', date('2021-11-08'), 2);
insert into ADHERENTS values (3, 'MEDINA', 'Enzo', '4 Rue Georges Bonnac, 33000 Bordeaux', date('2021-11-08'), 1);
insert into ADHERENTS values (4, 'FORNES', 'Guillaume', 'Studio 2, Talence', date('2021-11-15'), 4);

commit;

-- EMPRUNTS

CALL ajout_emprunt(date('2021-11-08'), time('08:00:00'), 1, 1, 1);          -- Emprunt 1 => Adhérent 1 dans Station 1 Vélo 1
CALL ajout_emprunt(date('2021-11-08'), time('13:30:00'), 2, 2, 2);          -- Emprunt 2
CALL fin_emprunt(2, date('2021-11-08'), time('14:00:00'), 55, 5);           -- Fin Emprunt 2
CALL ajout_emprunt(date('2021-11-08'), time('16:00:00'), 5, 4, 2);          -- Emprunt 3 => Adhérent 4 dans Station 5 Vélo 2
CALL fin_emprunt(3, date('2021-11-08'), time('18:00:00'), 75, 4);           -- Fin Emprunt 3
CALL fin_emprunt(1, date('2021-11-08'), time('20:00:00'), 100, 1);          -- Fin Emprunt 1
CALL ajout_emprunt(date('2021-11-08'), time('21:00:00'), 1, 3, 1);          -- Emprunt 4
CALL ajout_emprunt(date('2021-11-08'), time('21:30:00'), 6, 1, 14);         -- Emprunt 5
CALL fin_emprunt(5, date('2021-11-08'), time('23:00:00'), 100, 1);          -- Fin Emprunt 5
CALL fin_emprunt(4, date('2021-11-09'), time('08:00:00'), 125, 3);          -- Fin Emprunt 4

CALL ajout_emprunt(date('2021-11-13'), time('10:00:00'), 6, 4, 15);         -- Emprunt 6
CALL fin_emprunt(6, date('2021-11-13'), time('11:00:00'), 55, 6);           -- Fin Emprunt 6  (20 km parcouru)
CALL ajout_emprunt(date('2021-11-13'), time('14:00:00'), 6, 4, 15);         -- Emprunt 7
CALL fin_emprunt(7, date('2021-11-13'), time('16:00:00'), 85, 6);           -- Fin Emprunt 7  (30km parcouru)

CALL ajout_emprunt(date('2021-11-15'), time('7:25:00'), 1,  2, 14);         -- Emprunt 8
CALL ajout_emprunt(date('2021-11-16'), time('5:30:00'), 3, 3, 1);           -- Emprunt 9
CALL fin_emprunt(9, date('2021-11-16'), time('8:45:00'), 175, 1);           -- Fin Emprunt 9
CALL fin_emprunt(8, date('2021-11-17'), time('16:00:00'), 142, 4);          -- Fin Emprunt 8


-- Faux Emprunts (Test des triggers)


commit;

-- ============================================================
--    verification des donnees
-- ============================================================

select count(*),'= 1 ?','COMMUNES' from COMMUNES
union
select count(*),'= 1 ?','STATIONS' from STATIONS 
union
select count(*),'= 1 ?','VELOS' from VELOS
union
select count(*),'= 1 ?','ADHERENTS' from ADHERENTS 
union
select count(*),'= 1 ?','EMPRUNTS' from EMPRUNTS;