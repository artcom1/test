CREATE VIEW danerozliczeniaroz AS
 SELECT rr.rr_idrozrachunku AS rd_iddanerozrachunkuprawa,
    rr.rr_idwaluty AS wl_idwaluty,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_kwotawnwal
            ELSE rr.rr_kwotamawal
        END AS wartoscrozrachunkup_waluta,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpln
            ELSE rr.rr_wartoscmapln
        END AS wartoscrozrachunkup_pln,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpozwal
            ELSE rr.rr_wartoscmapozwal
        END AS wartoscdorozliczeniap_waluta,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpozpln
            ELSE rr.rr_wartoscmapozpln
        END AS wartoscdorozliczeniap_pln,
    rr.rr_dataplatnosci AS terminwymagalnoscip,
    rr.rr_datadokumentu AS datadokumentu,
    (((("substring"(((((((tg_transakcje.tr_numer || '/'::text) || btrim((tg_transakcje.tr_seria)::text)) || '/'::text) || tg_transakcje.tr_infix) || '/'::text) || (tg_transakcje.tr_rok)::text), 0, 50))::character varying(50))::text || '/'::text) || tg_transakcje.tr_rodzaj) AS dokument_numer,
    kh_platnosci.pl_numer AS platnosc_numer,
    kh_zapisyhead.zk_numer AS kh_numer
   FROM ((((public.kr_rozrachunki rr
     LEFT JOIN public.tg_transakcje USING (tr_idtrans))
     LEFT JOIN public.kh_platnosci USING (pl_idplatnosc))
     LEFT JOIN public.kh_zapisyelem USING (zp_idelzapisu))
     LEFT JOIN public.kh_zapisyhead USING (zk_idzapisu))
  WHERE ((rr.rr_flaga & 7) = ANY (ARRAY[0, 3, 5]));
