CREATE VIEW grupa_ii_odbiorcy AS
 SELECT ts_wagiklienta.wk_idwagi AS grupa_ii_odbiorcy,
    ts_wagiklienta.wk_opis AS nazwa_grupy_ii_odbiorcy
   FROM public.ts_wagiklienta;
