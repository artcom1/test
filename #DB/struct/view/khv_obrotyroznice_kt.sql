CREATE VIEW khv_obrotyroznice_kt AS
 SELECT a.kt_idkonta,
    a.kt_wnbuf,
    a.wn,
    a.kt_mabuf,
    a.ma
   FROM ( SELECT kt.kt_idkonta,
            kt.kt_wnbuf,
            kt.kt_mabuf,
            nullzero(( SELECT sum(ze.zp_kwota) AS sum
                   FROM kh_zapisyelem ze
                  WHERE ((ze.kt_idkontawn = kt.kt_idkonta) AND (ze.mc_miesiac IS NOT NULL)))) AS wn,
            nullzero(( SELECT sum(ze.zp_kwota) AS sum
                   FROM kh_zapisyelem ze
                  WHERE ((ze.kt_idkontama = kt.kt_idkonta) AND (ze.mc_miesiac IS NOT NULL)))) AS ma
           FROM kh_konta kt
          WHERE ((kt.kt_flaga & 2) = 0)) a
  WHERE ((a.kt_wnbuf <> a.wn) OR (a.kt_mabuf <> a.ma));
