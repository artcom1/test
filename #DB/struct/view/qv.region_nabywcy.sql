CREATE VIEW region_nabywcy AS
 SELECT ts_regiony.rj_idregionu AS region_nabywcy,
    ts_regiony.rj_nazwa AS regionnabywcy
   FROM public.ts_regiony;
