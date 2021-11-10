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

commit;

-- VELOS

insert into VELOS values (1, 'Tilt 500 E', "B'Twin", date('2021-11-08'), 0, 'NEUF', 100, 1);
insert into VELOS values (2, 'ELOPS 920', "ELOPS", date('2021-10-08'), 45, 'BON', 70, NULL); 

commit;

-- ADHERENTS

insert into ADHERENTS values (1, 'MOREL', 'Pierre-Jean', '7 Rue Salvador Allende, 33400 Talence', date('2021-11-08'), 3);
insert into ADHERENTS values (2, 'MARAIS', 'Lucas', ',7 Rue Léo Ferré 33400 Pessac', date('2021-11-08'), 2);
insert into ADHERENTS values (3, 'MEDINA', 'Enzo', '7 Rue Georges Bonnac, 33000 Bordeaux', date('2021-11-08'), 1);

commit;

-- EMPRUNTS

insert into EMPRUNTS values (1, date('2021-11-08'), time('23:21:00'), 45, 1, NULL, NULL, NULL, NULL, 1, 2);

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