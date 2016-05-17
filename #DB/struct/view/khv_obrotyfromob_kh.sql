CREATE VIEW khv_obrotyfromob_kh AS
 SELECT khv_obrotyfromob.wn,
    khv_obrotyfromob.ma,
    khv_obrotyfromob.kt_idkonta,
    khv_obrotyfromob.mc_miesiac
   FROM khv_obrotyfromob
  WHERE (khv_obrotyfromob.mc_miesiac IS NOT NULL);
