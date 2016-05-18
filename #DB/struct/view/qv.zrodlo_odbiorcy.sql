CREATE VIEW zrodlo_odbiorcy AS
 SELECT ts_zrodloinf.zi_idzrodla AS zrodlo_odbiorcy,
    ts_zrodloinf.zi_opis AS nazwazrodlaodbiorcy
   FROM public.ts_zrodloinf;
