CREATE VIEW kv_raport_te AS
 SELECT a.tel_idelem,
    a.tr_idtrans,
    a.tel_wnettodok,
    a.tel_stvat,
    a.tel_flaga,
    a.tel_iloscwyd,
    round((a.tel_cenakgodok * a.tel_iloscf), 2) AS tel_wnettodokkgo,
    round((a.tel_cenabdok * a.tel_ilosc), 2) AS tel_wbruttodok,
    round((round(public.net2brt(a.tel_cenakgodok, a.tel_stvat), 2) * a.tel_iloscf), 2) AS tel_wbruttodokkgo
   FROM public.tg_transelem a;
