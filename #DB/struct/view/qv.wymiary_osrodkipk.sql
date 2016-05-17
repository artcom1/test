CREATE VIEW wymiary_osrodkipk AS
 SELECT o.opk_idosrodka AS idosrodkapk_wymiaru,
    o.opk_kod AS kodopk_wymiaru,
    o.opk_nazwa AS nazwaopk_wymiaru
   FROM public.ts_osrodkipk o;
