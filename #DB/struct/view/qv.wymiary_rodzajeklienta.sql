CREATE VIEW wymiary_rodzajeklienta AS
 SELECT s.rk_idrodzajklienta AS idrodzajuklienta_wymiaru,
    s.rk_typrodzaju AS nazwarodzajuklienta_wymiaru
   FROM public.ts_rodzajklienta s;
