CREATE VIEW formyplatnosci AS
 SELECT ts_formaplat.pl_formaplat,
    ts_formaplat.fp_nazwa AS formaplatnosci
   FROM public.ts_formaplat;
