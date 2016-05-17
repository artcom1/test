CREATE VIEW khzapisy_normalized AS
 SELECT ze.zp_idelzapisu,
    ktwn.ktn_idkonta,
    ze.zp_nrdowodu,
    ze.zp_kwota AS zp_kwotawn,
    (0)::numeric AS zp_kwotama,
    ze.zp_kwotawal AS zp_kwotawnwal,
    (0)::numeric AS zp_kwotamawal,
    ze.wl_idwaluty,
    ktma.ktn_idkonta AS ktn_idkontaoposite,
    zk.zk_datadok,
    zk.mn_miesiac,
    zk.zk_fullnumer,
    zk.zk_opis,
    ze.zp_opis,
    ze.r_idroku,
    ze.kt_idkontawn AS kt_idkonta,
    zk.zk_typ AS zp_typ,
    zk.zk_flaga AS zp_flaga,
    l.fm_idcentrali AS idcentrali
   FROM ((((public.kh_zapisyelem ze
     JOIN public.kh_konta ktwn ON ((ktwn.kt_idkonta = ze.kt_idkontawn)))
     LEFT JOIN public.kh_konta ktma ON ((ktma.kt_idkonta = ze.kt_idkontama)))
     JOIN public.kh_zapisyhead zk ON ((zk.zk_idzapisu = ze.zk_idzapisu)))
     JOIN public.kh_lata l ON ((l.ro_idroku = zk.ro_idroku)))
  WHERE ((ze.mc_miesiac IS NOT NULL) AND (ze.kt_idkontawn IS NOT NULL))
UNION
 SELECT (- ze.zp_idelzapisu) AS zp_idelzapisu,
    ktma.ktn_idkonta,
    ze.zp_nrdowodu,
    (0)::numeric AS zp_kwotawn,
    ze.zp_kwota AS zp_kwotama,
    (0)::numeric AS zp_kwotawnwal,
    ze.zp_kwotawal AS zp_kwotamawal,
    ze.wl_idwaluty,
    ktwn.ktn_idkonta AS ktn_idkontaoposite,
    zk.zk_datadok,
    zk.mn_miesiac,
    zk.zk_fullnumer,
    zk.zk_opis,
    ze.zp_opis,
    ze.r_idroku,
    ze.kt_idkontama AS kt_idkonta,
    zk.zk_typ AS zp_typ,
    zk.zk_flaga AS zp_flaga,
    l.fm_idcentrali AS idcentrali
   FROM ((((public.kh_zapisyelem ze
     JOIN public.kh_konta ktma ON ((ktma.kt_idkonta = ze.kt_idkontama)))
     LEFT JOIN public.kh_konta ktwn ON ((ktwn.kt_idkonta = ze.kt_idkontawn)))
     JOIN public.kh_zapisyhead zk ON ((zk.zk_idzapisu = ze.zk_idzapisu)))
     JOIN public.kh_lata l ON ((l.ro_idroku = zk.ro_idroku)))
  WHERE ((ze.mc_miesiac IS NOT NULL) AND (ze.kt_idkontama IS NOT NULL));


SET search_path = qv, pg_catalog;
