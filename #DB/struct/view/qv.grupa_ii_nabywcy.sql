CREATE VIEW grupa_ii_nabywcy AS
 SELECT ts_wagiklienta.wk_idwagi AS grupa_ii_nabywcy,
    ts_wagiklienta.wk_opis AS nazwa_grupy_ii_nabywcy
   FROM public.ts_wagiklienta;
