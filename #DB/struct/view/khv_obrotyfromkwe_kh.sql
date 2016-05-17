CREATE VIEW khv_obrotyfromkwe_kh AS
 SELECT khv_obrotyfromkwe.wn,
    khv_obrotyfromkwe.ma,
    khv_obrotyfromkwe.kt_idkonta,
    khv_obrotyfromkwe.mc_miesiac
   FROM khv_obrotyfromkwe
  WHERE (khv_obrotyfromkwe.mc_miesiac IS NOT NULL);
