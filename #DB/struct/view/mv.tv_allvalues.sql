CREATE VIEW tv_allvalues AS
 SELECT tb_klient_mv.nmv_id,
    tb_klient_mv.k_idklienta AS idref,
    'mvv.tb_klient_mv'::text AS tablename
   FROM mvv.tb_klient_mv
UNION ALL
 SELECT tg_obiekty_mv.nmv_id,
    tg_obiekty_mv.ob_idobiektu AS idref,
    'mvv.tg_obiekty_mv'::text AS tablename
   FROM mvv.tg_obiekty_mv
UNION ALL
 SELECT tg_transakcje_mv.nmv_id,
    tg_transakcje_mv.tr_idtrans AS idref,
    'mvv.tg_transakcje_mv'::text AS tablename
   FROM mvv.tg_transakcje_mv
UNION ALL
 SELECT tg_magazyny_mv.nmv_id,
    tg_magazyny_mv.tmg_idmagazynu AS idref,
    'mvv.tg_magazyny_mv'::text AS tablename
   FROM mvv.tg_magazyny_mv
UNION ALL
 SELECT tg_towary_mv.nmv_id,
    tg_towary_mv.ttw_idtowaru AS idref,
    'mvv.tg_towary_mv'::text AS tablename
   FROM mvv.tg_towary_mv
UNION ALL
 SELECT tb_pracownicy_mv.nmv_id,
    tb_pracownicy_mv.p_idpracownika AS idref,
    'mvv.tb_pracownicy_mv'::text AS tablename
   FROM mvv.tb_pracownicy_mv
UNION ALL
 SELECT tg_grupytow_mv.nmv_id,
    tg_grupytow_mv.tgr_idgrupy AS idref,
    'mvv.tg_grupytow_mv'::text AS tablename
   FROM mvv.tg_grupytow_mv
UNION ALL
 SELECT tg_podgrupytow_mv.nmv_id,
    tg_podgrupytow_mv.tpg_idpodgrupy AS idref,
    'mvv.tg_podgrupytow_mv'::text AS tablename
   FROM mvv.tg_podgrupytow_mv
UNION ALL
 SELECT tg_transelem_mv.nmv_id,
    tg_transelem_mv.tel_idelem AS idref,
    'mvv.tg_transelem_mv'::text AS tablename
   FROM mvv.tg_transelem_mv
UNION ALL
 SELECT kh_platnosci_mv.nmv_id,
    kh_platnosci_mv.pl_idplatnosc AS idref,
    'mvv.kh_platnosci_mv'::text AS tablename
   FROM mvv.kh_platnosci_mv
UNION ALL
 SELECT ts_banki_mv.nmv_id,
    ts_banki_mv.bk_idbanku AS idref,
    'mvv.ts_banki_mv'::text AS tablename
   FROM mvv.ts_banki_mv
UNION ALL
 SELECT tg_jednostki_mv.nmv_id,
    tg_jednostki_mv.tjn_idjedn AS idref,
    'mvv.tg_jednostki_mv'::text AS tablename
   FROM mvv.tg_jednostki_mv
UNION ALL
 SELECT ts_powiaty_mv.nmv_id,
    ts_powiaty_mv.pw_idpowiatu AS idref,
    'mvv.ts_powiaty_mv'::text AS tablename
   FROM mvv.ts_powiaty_mv
UNION ALL
 SELECT tg_zlecenia_mv.nmv_id,
    tg_zlecenia_mv.zl_idzlecenia AS idref,
    'mvv.tg_zlecenia_mv'::text AS tablename
   FROM mvv.tg_zlecenia_mv
UNION ALL
 SELECT tb_ludzieklienta_mv.nmv_id,
    tb_ludzieklienta_mv.lk_idczklienta AS idref,
    'mvv.tb_ludzieklienta_mv'::text AS tablename
   FROM mvv.tb_ludzieklienta_mv
UNION ALL
 SELECT tg_planzlecenia_mv.nmv_id,
    tg_planzlecenia_mv.pz_idplanu AS idref,
    'mvv.tg_planzlecenia_mv'::text AS tablename
   FROM mvv.tg_planzlecenia_mv
UNION ALL
 SELECT tg_klientzlecenia_mv.nmv_id,
    tg_klientzlecenia_mv.kz_idklienta AS idref,
    'mvv.tg_klientzlecenia_mv'::text AS tablename
   FROM mvv.tg_klientzlecenia_mv
UNION ALL
 SELECT tb_firma_mv.nmv_id,
    tb_firma_mv.fm_index AS idref,
    'mvv.tb_firma_mv'::text AS tablename
   FROM mvv.tb_firma_mv
UNION ALL
 SELECT tg_elslownika_mv.nmv_id,
    tg_elslownika_mv.es_idelem AS idref,
    'mvv.tg_elslownika_mv'::text AS tablename
   FROM mvv.tg_elslownika_mv
UNION ALL
 SELECT st_srodkitrwale_mv.nmv_id,
    st_srodkitrwale_mv.str_id AS idref,
    'mvv.st_srodkitrwale_mv'::text AS tablename
   FROM mvv.st_srodkitrwale_mv
UNION ALL
 SELECT ts_spedycje_mv.nmv_id,
    ts_spedycje_mv.sp_idspedytora AS idref,
    'mvv.ts_spedycje_mv'::text AS tablename
   FROM mvv.ts_spedycje_mv
UNION ALL
 SELECT tg_transport_mv.nmv_id,
    tg_transport_mv.lt_idtransportu AS idref,
    'mvv.tg_transport_mv'::text AS tablename
   FROM mvv.tg_transport_mv
UNION ALL
 SELECT tr_technologie_mv.nmv_id,
    tr_technologie_mv.th_idtechnologii AS idref,
    'mvv.tr_technologie_mv'::text AS tablename
   FROM mvv.tr_technologie_mv
UNION ALL
 SELECT tr_technoelem_mv.nmv_id,
    tr_technoelem_mv.the_idelem AS idref,
    'mvv.tr_technoelem_mv'::text AS tablename
   FROM mvv.tr_technoelem_mv
UNION ALL
 SELECT tr_operacjetech_mv.nmv_id,
    tr_operacjetech_mv.top_idoperacji AS idref,
    'mvv.tr_operacjetech_mv'::text AS tablename
   FROM mvv.tr_operacjetech_mv
UNION ALL
 SELECT tr_rrozchodu_mv.nmv_id,
    tr_rrozchodu_mv.trr_idelemu AS idref,
    'mvv.tr_rrozchodu_mv'::text AS tablename
   FROM mvv.tr_rrozchodu_mv
UNION ALL
 SELECT tr_kkwhead_mv.nmv_id,
    tr_kkwhead_mv.kwh_idheadu AS idref,
    'mvv.tr_kkwhead_mv'::text AS tablename
   FROM mvv.tr_kkwhead_mv
UNION ALL
 SELECT tr_kkwnod_mv.nmv_id,
    tr_kkwnod_mv.kwe_idelemu AS idref,
    'mvv.tr_kkwnod_mv'::text AS tablename
   FROM mvv.tr_kkwnod_mv
UNION ALL
 SELECT tr_kkwnodwyk_mv.nmv_id,
    tr_kkwnodwyk_mv.knw_idelemu AS idref,
    'mvv.tr_kkwnodwyk_mv'::text AS tablename
   FROM mvv.tr_kkwnodwyk_mv
UNION ALL
 SELECT tr_nodrec_mv.nmv_id,
    tr_nodrec_mv.knr_idelemu AS idref,
    'mvv.tr_nodrec_mv'::text AS tablename
   FROM mvv.tr_nodrec_mv
UNION ALL
 SELECT ts_formaplat_mv.nmv_id,
    ts_formaplat_mv.pl_formaplat AS idref,
    'mvv.ts_formaplat_mv'::text AS tablename
   FROM mvv.ts_formaplat_mv
UNION ALL
 SELECT tr_ciagtech_mv.nmv_id,
    tr_ciagtech_mv.ct_idciagu AS idref,
    'mvv.tr_ciagtech_mv'::text AS tablename
   FROM mvv.tr_ciagtech_mv
UNION ALL
 SELECT tg_abonamenty_mv.nmv_id,
    tg_abonamenty_mv.ab_idabonamentu AS idref,
    'mvv.tg_abonamenty_mv'::text AS tablename
   FROM mvv.tg_abonamenty_mv
UNION ALL
 SELECT tg_abonamelem_mv.nmv_id,
    tg_abonamelem_mv.ae_idelemu AS idref,
    'mvv.tg_abonamelem_mv'::text AS tablename
   FROM mvv.tg_abonamelem_mv
UNION ALL
 SELECT ts_grupycen_mv.nmv_id,
    ts_grupycen_mv.tgc_idgrupy AS idref,
    'mvv.ts_grupycen_mv'::text AS tablename
   FROM mvv.ts_grupycen_mv
UNION ALL
 SELECT tr_technogrupy_mv.nmv_id,
    tr_technogrupy_mv.thg_idgrupy AS idref,
    'mvv.tr_technogrupy_mv'::text AS tablename
   FROM mvv.tr_technogrupy_mv
UNION ALL
 SELECT tg_grupywww_mv.nmv_id,
    tg_grupywww_mv.tgw_idgrupy AS idref,
    'mvv.tg_grupywww_mv'::text AS tablename
   FROM mvv.tg_grupywww_mv
UNION ALL
 SELECT tb_zdarzenia_mv.nmv_id,
    tb_zdarzenia_mv.zd_idzdarzenia AS idref,
    'mvv.tb_zdarzenia_mv'::text AS tablename
   FROM mvv.tb_zdarzenia_mv
UNION ALL
 SELECT tg_swiadectwa_mv.nmv_id,
    tg_swiadectwa_mv.sw_idswiadectwa AS idref,
    'mvv.tg_swiadectwa_mv'::text AS tablename
   FROM mvv.tg_swiadectwa_mv
UNION ALL
 SELECT tg_rodzajedokumentow_mv.nmv_id,
    tg_rodzajedokumentow_mv.tr_rodzaj AS idref,
    'mvv.tg_rodzajedokumentow_mv'::text AS tablename
   FROM mvv.tg_rodzajedokumentow_mv
UNION ALL
 SELECT tg_praceall_mv.nmv_id,
    tg_praceall_mv.pra_idpracy AS idref,
    'mvv.tg_praceall_mv'::text AS tablename
   FROM mvv.tg_praceall_mv
UNION ALL
 SELECT ts_slownikwykonania_mv.nmv_id,
    ts_slownikwykonania_mv.tsw_idslownika AS idref,
    'mvv.ts_slownikwykonania_mv'::text AS tablename
   FROM mvv.ts_slownikwykonania_mv
UNION ALL
 SELECT tg_kpohead_mv.nmv_id,
    tg_kpohead_mv.kpo_idheadu AS idref,
    'mvv.tg_kpohead_mv'::text AS tablename
   FROM mvv.tg_kpohead_mv
UNION ALL
 SELECT tb_kalendarzhead_mv.nmv_id,
    tb_kalendarzhead_mv.kalh_idkalendarzahead AS idref,
    'mvv.tb_kalendarzhead_mv'::text AS tablename
   FROM mvv.tb_kalendarzhead_mv
UNION ALL
 SELECT tg_partie_mv.nmv_id,
    tg_partie_mv.prt_idpartii AS idref,
    'mvv.tg_partie_mv'::text AS tablename
   FROM mvv.tg_partie_mv
UNION ALL
 SELECT tg_teex_mv.nmv_id,
    tg_teex_mv.tex_idelem AS idref,
    'mvv.tg_teex_mv'::text AS tablename
   FROM mvv.tg_teex_mv
UNION ALL
 SELECT tg_partiehelper_mv.nmv_id,
    tg_partiehelper_mv.prh_idpartii AS idref,
    'mvv.tg_partiehelper_mv'::text AS tablename
   FROM mvv.tg_partiehelper_mv
UNION ALL
 SELECT tg_charklientdlatow_mv.nmv_id,
    tg_charklientdlatow_mv.ckdt_idkartoteki AS idref,
    'mvv.tg_charklientdlatow_mv'::text AS tablename
   FROM mvv.tg_charklientdlatow_mv
UNION ALL
 SELECT tr_pomiary_definicje_mv.nmv_id,
    tr_pomiary_definicje_mv.pd_iddefinicji AS idref,
    'mvv.tr_pomiary_definicje_mv'::text AS tablename
   FROM mvv.tr_pomiary_definicje_mv
UNION ALL
 SELECT tr_pomiary_wykonanie_mv.nmv_id,
    tr_pomiary_wykonanie_mv.pw_idpomiarukkw AS idref,
    'mvv.tr_pomiary_wykonanie_mv'::text AS tablename
   FROM mvv.tr_pomiary_wykonanie_mv;


SET search_path = public, pg_catalog;
