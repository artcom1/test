CREATE VIEW kraj_nabywcy AS
 SELECT ts_powiaty.pw_idpowiatu AS kraj_nabywcy,
    ts_powiaty.pw_nazwa AS nazwa_panstwa_nabywcy,
    ts_powiaty.pw_wojewodztwo AS symbol_panstwa_nabywcy
   FROM public.ts_powiaty;
