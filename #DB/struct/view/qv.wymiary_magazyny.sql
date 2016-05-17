CREATE VIEW wymiary_magazyny AS
 SELECT m.tmg_idmagazynu AS idmagazynu_wymiaru,
    m.tmg_kod AS kodmagazynu_wymiaru,
    m.tmg_nazwa AS nazwamagazynu_wymiaru
   FROM public.tg_magazyny m;
