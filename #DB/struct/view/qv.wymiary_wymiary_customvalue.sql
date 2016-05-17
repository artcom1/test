CREATE VIEW wymiary_wymiary_customvalue AS
 SELECT s.wms_idwymiaru AS wymiar_customvalue_wymiar,
    s.wms_nazwa AS nazwa_customwymiaru,
    s.wms_isactive AS aktywnosc_customwymiaru,
    s.fm_idcentrali AS centrala_customwymiaru
   FROM qvi.wymiaryslownik s
  WHERE (s.wms_datatype = 0);
