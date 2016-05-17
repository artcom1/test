CREATE VIEW rodzaje_odbiorcy AS
 SELECT ts_rodzajklienta.rk_idrodzajklienta AS grupa_odbiorcy,
    ts_rodzajklienta.rk_typrodzaju AS rodzajodbiorcy,
    ts_rodzajklienta.rk_sciezka AS sciezkaodbiorcy
   FROM public.ts_rodzajklienta;
