CREATE VIEW wymiary_wymiary AS
 SELECT s.wms_idwymiaru AS idwymiaru,
    s.wms_nazwa AS nazwa_wymiaru,
    s.wms_isactive AS aktywnosc_wymiaru,
    s.fm_idcentrali AS centrala_wymiaru
   FROM qvi.wymiaryslownik s;
