CREATE VIEW khv_obrotyfromkwe AS
 SELECT sum(a.wn) AS wn,
    sum(a.ma) AS ma,
    a.kt_idkonta,
    a.mc_miesiac
   FROM ( SELECT sum(kh_zapisyelem.zp_kwota) AS wn,
            0 AS ma,
            kh_zapisyelem.kt_idkontawn AS kt_idkonta,
            kh_zapisyelem.mc_miesiac
           FROM kh_zapisyelem
          WHERE (kh_zapisyelem.kt_idkontawn IS NOT NULL)
          GROUP BY kh_zapisyelem.kt_idkontawn, kh_zapisyelem.mc_miesiac
        UNION
         SELECT 0,
            sum(kh_zapisyelem.zp_kwota) AS wma,
            kh_zapisyelem.kt_idkontama AS kt_idkonta,
            kh_zapisyelem.mc_miesiac
           FROM kh_zapisyelem
          WHERE (kh_zapisyelem.kt_idkontama IS NOT NULL)
          GROUP BY kh_zapisyelem.kt_idkontama, kh_zapisyelem.mc_miesiac) a
  GROUP BY a.kt_idkonta, a.mc_miesiac;
