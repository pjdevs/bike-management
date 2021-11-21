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
insert into STATIONS values (2, 'Place Pey Berland 33000, Bordeaux', 30, 1, 44.83772845,-0.5765286471688031); 
insert into STATIONS values (3, '42 rue Marc Sangnier 33400 Talence', 25, 3, 44.8084094, -0.6037152);
insert into STATIONS values (4, '12 Rue Camille Pelletan 33400 Talence', 50, 3, 44.8128305, -0.5909929); 
insert into STATIONS values (5, 'Avenue René Cassin 33700 Mérignac', 200, 4, 44.8332441, -0.686935); 
insert into STATIONS values (6, '4 Bis Rue Antoine Becquerel 33600 Pessac', 45, 2, 44.7904825,-0.6504596); 

commit;

-- VELOS

insert into VELOS values (1, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 0, 'NEUF', 100, 1);
insert into VELOS values (2, 'ELOPS 920', "ELOPS", date('2021-10-08'), 45, 'BON', 70, NULL); 
insert into VELOS values (3, 'XC 100 S', "ROCK RIDER", date('2021-11-01'), 0, 'NEUF', 100, 5);
insert into VELOS values (4, 'RIVERSIDE 500', "RIVERSIDE", date('2021-11-01'), 100, 'MOYEN', 50, 6); 
insert into VELOS values (5, 'RIVERSIDE 920 E', "RIVERSIDE", date('2021-11-01'), 90, 'BON', 60, 3);
insert into VELOS values (6, 'ELOPS 120 E', "ELOPS", date('2021-11-05'), 720, 'MAUVAIS', 20, 4); 
insert into VELOS values (7, 'ELOPS 900 E', "ELOPS", date('2021-11-05'), 220, 'MOYEN', 70, 2); 
insert into VELOS values (8, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 20, 'NEUF', 80, 1);
insert into VELOS values (9, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 107, 'MOYEN', 50, 1);
insert into VELOS values (10, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 112, 'MOYEN', 44, 1);

commit;

-- ADHERENTS

insert into ADHERENTS values (1, 'MOREL', 'Pierre-Jean', '7 Rue Salvador Allende, 33400 Talence', date('2021-11-08'), 3);
insert into ADHERENTS values (2, 'MARAIS', 'Lucas', ',7 Rue Léo Ferré 33400 Pessac', date('2021-11-08'), 2);
insert into ADHERENTS values (3, 'MEDINA', 'Enzo', '4 Rue Georges Bonnac, 33000 Bordeaux', date('2021-11-08'), 1);
insert into ADHERENTS values (4, 'FORNES', 'Guillaume', 'Adresse', date('2021-11-15'), 4);

commit;

-- EMPRUNTS

insert into EMPRUNTS values (1, date('2021-11-08'), time('23:21:00'), 45, 1, NULL, NULL, NULL, NULL, 1, 2);
insert into EMPRUNTS values (2, date('2021-11-12'), time('7:50:00'), 0, 5, date('2021-11-12'), time('8:10:00'), 5, 6, 1, 3); 
insert into EMPRUNTS values (3, date('2021-11-12'), time('9:15:00'), 0, 1, date('2021-11-12'), time('9:25:00'), 3, 3, 3, 1);
insert into EMPRUNTS values (4, date('2021-11-12'), time('12:00:00'), 720, 4, date('2021-11-12'), time('14:00:00'), 750, 1, 2, 6);
insert into EMPRUNTS values (5, date('2021-11-12'), time('14:30:00'), 90, 3, date('2021-11-12'), time('15:15:00'), 110, 4, 3, 5); 
insert into EMPRUNTS values (6, date('2021-11-12'), time('16:25:00', 750, 4, date('2021-11-12'), time('17:30:00'), 765, 2, 4, 6)); 
insert into EMPRUNTS values (7, date('2021-11-12'), time('18:10:00'), 100, 6, date('2021-11-12'), time('18:40:40'), 110, 2, 1, 4); 
insert into EMPRUNTS values (8, date('2021-11-15'), time('9:40:40'), 5, 5, NULL, NULL, NULL, NULL, 2, 3); 
insert into EMPRUNTS values (9, date('2021-11-15'), time('13:20:00'), 0, 1, NULL, NULL, NULL, NULL, 1, 1); 


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