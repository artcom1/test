CREATE VIEW kraj_odbiorcy AS
 SELECT ts_powiaty.pw_idpowiatu AS kraj_odbiorcy,
    ts_powiaty.pw_nazwa AS nazwa_panstwa_odbiorcy,
    ts_powiaty.pw_wojewodztwo AS symbol_panstwa_odbiorcy
   FROM public.ts_powiaty;
