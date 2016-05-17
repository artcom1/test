CREATE VIEW checkkhobroty AS
 SELECT k.kt_idkonta
   FROM kh_konta k
  WHERE (((k.kt_flaga & 2) = 0) AND (nullzero(( SELECT sum(o.ob_wnbuf) AS sum
           FROM kh_obroty o
          WHERE (o.kt_idkonta = k.kt_idkonta))) <> nullzero(( SELECT sum(e.zp_kwota) AS sum
           FROM kh_zapisyelem e
          WHERE (e.kt_idkontawn = k.kt_idkonta)))));
