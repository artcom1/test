CREATE VIEW kv_docbystawka_inner AS
 SELECT tei.tel_idelem,
    tei.tr_idtrans,
    tei.tel_stvat,
    round((tei.tel_cenabdok * tei.tel_ilosc), 2) AS tel_wbruttodok,
    tei.tel_flaga,
    tei.tel_iloscwyd,
    tei.tel_ilosc,
    tei.tel_wnettodok,
    false AS iswal,
    NULL::integer AS tel_waluta,
    false AS iskgo
   FROM public.tg_transelem tei
  WHERE ((tei.tel_flaga & 1024) = 0)
UNION ALL
 SELECT tei.tel_idelem,
    tei.tr_idtrans,
    tei.tel_stvat,
    round((tei.tel_cenabwal * tei.tel_ilosc), 2) AS tel_wbruttodok,
    tei.tel_flaga,
    tei.tel_iloscwyd,
    tei.tel_ilosc,
    tei.tel_wnettowal AS tel_wnettodok,
    true AS iswal,
    tei.tel_walutawal AS tel_waluta,
    false AS iskgo
   FROM public.tg_transelem tei
  WHERE ((tei.tel_flaga & 1024) = 0)
UNION ALL
 SELECT tei.tel_idelem,
    tei.tr_idtrans,
    tei.tel_stvat,
    round((round(public.net2brt(tei.tel_cenakgodok, tei.tel_stvat), 2) * tei.tel_iloscf), 2) AS tel_wbruttodok,
    tei.tel_flaga,
    tei.tel_iloscf AS tel_iloscwyd,
    tei.tel_iloscf AS tel_ilosc,
    round((tei.tel_cenakgodok * tei.tel_iloscf), 2) AS tel_wnettodok,
    false AS iswal,
    NULL::integer AS tel_waluta,
    true AS iskgo
   FROM public.tg_transelem tei
  WHERE (((tei.tel_flaga & 1024) = 0) AND (tei.tel_cenakgodok <> (0)::numeric))
UNION ALL
 SELECT tei.tel_idelem,
    tei.tr_idtrans,
    tei.tel_stvat,
    round((round(public.net2brt(tei.tel_cenakgodok, tei.tel_stvat), 2) * tei.tel_iloscf), 2) AS tel_wbruttodok,
    tei.tel_flaga,
    tei.tel_iloscf AS tel_iloscwyd,
    tei.tel_iloscf AS tel_ilosc,
    round((tei.tel_cenakgodok * tei.tel_iloscf), 2) AS tel_wnettodok,
    true AS iswal,
    tg_transakcje.wl_idwaluty AS tel_waluta,
    true AS iskgo
   FROM (public.tg_transelem tei
     JOIN public.tg_transakcje USING (tr_idtrans))
  WHERE (((tei.tel_flaga & 1024) = 0) AND (tei.tel_cenakgodok <> (0)::numeric));
