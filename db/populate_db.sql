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

commit;

-- STATIONS

insert into STATIONS values (1, '1 Avenue du Dr Albert Shweitzer 33400 Talence', 10, 1);

commit;

-- VELOS

insert into VELOS values (1, 'RC360', 'Rockrider', date('2021-11-08'), 0, 'Bon état', 100, 1);

commit;

-- ADHERENTS

insert into ADHERENTS values (1, 'Morel', 'PJ', '7 Rue Salvador Allende 33400 Talence', date('2021-11-08'), 1);

commit;

-- EMPRUNTS

insert into EMPRUNTS values (1, date('2021-11-08'), time('23:21:00'), 10, date('2021-11-09'), time('05:48:54'), 20, 1, 1, 1, 1);

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