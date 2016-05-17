CREATE VIEW kv_raport_bystawka_oinner AS
 SELECT tei.tel_idelem,
    tei.tr_idtrans,
    tei.tel_wnettodok,
    tei.tel_stvat,
    tei.tel_flaga,
    tei.tel_iloscwyd,
    tei.tel_wnettodokkgo,
    tei.tel_wbruttodok,
    tei.tel_wbruttodokkgo
   FROM kv_raport_te tei
  WHERE (public.iscopied(tei.tel_flaga) OR ((tei.tel_flaga & (1024 | 32768)) = 0));
