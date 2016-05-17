CREATE VIEW rodzaje_nabywcy AS
 SELECT ts_rodzajklienta.rk_idrodzajklienta AS grupa_nabywcy,
    ts_rodzajklienta.rk_typrodzaju AS rodzajnabywcy,
    ts_rodzajklienta.rk_sciezka AS sciezkanabywcy
   FROM public.ts_rodzajklienta;
