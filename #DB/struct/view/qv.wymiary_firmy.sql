CREATE VIEW wymiary_firmy AS
 SELECT f.fm_index AS idfirmy_wymiaru,
    f.fm_kod AS kodfirmy_wymiaru,
    f.fm_nazwa AS nazwafirmy_wymiaru
   FROM public.tb_firma f;
