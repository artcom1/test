CREATE VIEW khv_obrotyfromob AS
 SELECT sum(kh_obroty.ob_wnbuf) AS wn,
    sum(kh_obroty.ob_mabuf) AS ma,
    kh_obroty.kt_idkonta,
    kh_obroty.mn_miesiac AS mc_miesiac
   FROM (kh_obroty
     JOIN kh_konta USING (kt_idkonta))
  WHERE ((kh_konta.kt_flaga & 2) = 0)
  GROUP BY kh_obroty.kt_idkonta, kh_obroty.mn_miesiac;
