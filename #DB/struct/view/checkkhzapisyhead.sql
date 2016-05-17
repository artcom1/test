CREATE VIEW checkkhzapisyhead AS
 SELECT kh_zapisyhead.zk_idzapisu,
    kh_zapisyhead.zk_wn,
    kh_zapisyhead.zk_ma,
    nullzero(( SELECT sum(kh_zapisyelem.zp_kwota) AS sum
           FROM kh_zapisyelem
          WHERE ((kh_zapisyelem.zk_idzapisu = kh_zapisyhead.zk_idzapisu) AND (kh_zapisyelem.kt_idkontawn IS NOT NULL) AND ((kh_zapisyelem.zp_flaga & 16) = 0)))) AS zk_wnok,
    nullzero(( SELECT sum(kh_zapisyelem.zp_kwota) AS sum
           FROM kh_zapisyelem
          WHERE ((kh_zapisyelem.zk_idzapisu = kh_zapisyhead.zk_idzapisu) AND (kh_zapisyelem.kt_idkontama IS NOT NULL) AND ((kh_zapisyelem.zp_flaga & 32) = 0)))) AS zk_maok
   FROM kh_zapisyhead
  WHERE ((kh_zapisyhead.zk_wn <> nullzero(( SELECT sum(kh_zapisyelem.zp_kwota) AS sum
           FROM kh_zapisyelem
          WHERE ((kh_zapisyelem.zk_idzapisu = kh_zapisyhead.zk_idzapisu) AND (kh_zapisyelem.kt_idkontawn IS NOT NULL) AND ((kh_zapisyelem.zp_flaga & 16) = 0))))) OR (kh_zapisyhead.zk_ma <> nullzero(( SELECT sum(kh_zapisyelem.zp_kwota) AS sum
           FROM kh_zapisyelem
          WHERE ((kh_zapisyelem.zk_idzapisu = kh_zapisyhead.zk_idzapisu) AND (kh_zapisyelem.kt_idkontama IS NOT NULL) AND ((kh_zapisyelem.zp_flaga & 32) = 0))))));
