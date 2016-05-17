CREATE VIEW wymiaryslownik AS
 SELECT s.wms_idwymiaru,
    s.wms_nazwa,
    s.wms_isactive,
    s.fm_idcentrali,
    s.wms_datatype
   FROM public.kh_wymiaryslownik s;


SET search_path = qv, pg_catalog;
