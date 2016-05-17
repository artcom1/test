CREATE VIEW region_odbiorcy AS
 SELECT ts_regiony.rj_idregionu AS region_odbiorcy,
    ts_regiony.rj_nazwa AS regionodbiorcy
   FROM public.ts_regiony;
