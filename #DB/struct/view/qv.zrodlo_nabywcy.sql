CREATE VIEW zrodlo_nabywcy AS
 SELECT ts_zrodloinf.zi_idzrodla AS zrodlo_nabywcy,
    ts_zrodloinf.zi_opis AS nazwazrodlanabywcy
   FROM public.ts_zrodloinf;
