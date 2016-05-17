CREATE VIEW kv_raport_vat_o AS
 SELECT t.tr_idtrans,
    sum(t.netto) AS netto,
    sum(t.vat) AS vat,
    sum(t.brutto) AS brutto,
    sum((t.netto - t.netnetto)) AS kgonetto,
    sum((t.vat - t.netvat)) AS kgovat,
    sum((t.brutto - t.netbrutto)) AS kgobrutto,
    sum(t.netnetto) AS netnetto,
    sum(t.netvat) AS netvat,
    sum(t.netbrutto) AS netbrutto,
    sum(t.l_pozycji) AS l_pozycji,
    sum(t.iloscmmized) AS iloscmmized,
    sum(t.tel_iloscwyd_sum) AS tel_iloscwyd_sum,
    sum(t.iloscoo) AS iloscoo
   FROM ( SELECT 1,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum((rbs.tel_brutto - rbs.tel_vatb))
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum((rbs.tel_brutto - rbs.tel_vatb2))
                    ELSE sum(rbs.tel_netto)
                END AS netto,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum(rbs.tel_vatb)
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum(rbs.tel_vatb2)
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (1 << 17)) THEN sum(rbs.tel_vat2)
                    ELSE sum(rbs.tel_vat)
                END AS vat,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & 128) = 128) THEN sum(rbs.tel_brutto)
                    WHEN ((tg_transakcje.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN sum((rbs.tel_netto + rbs.tel_vat2))
                    ELSE sum((rbs.tel_netto + rbs.tel_vat))
                END AS brutto,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum((rbs.tel_netbrutto - rbs.tel_netvatb))
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum((rbs.tel_netbrutto - rbs.tel_netvatb2))
                    ELSE sum(rbs.tel_netnetto)
                END AS netnetto,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum(rbs.tel_netvatb)
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum(rbs.tel_netvatb2)
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (1 << 17)) THEN sum(rbs.tel_netvat2)
                    ELSE sum(rbs.tel_netvat)
                END AS netvat,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & 128) = 128) THEN sum(rbs.tel_netbrutto)
                    WHEN ((tg_transakcje.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN sum((rbs.tel_netnetto + rbs.tel_netvat2))
                    ELSE sum((rbs.tel_netnetto + rbs.tel_netvat))
                END AS netbrutto,
            sum(rbs.l_pozycji) AS l_pozycji,
            public.nullzero(public.max((0)::numeric, ceil(public.min((1)::numeric, sum(rbs.tel_iloscwyd_sum))))) AS iloscmmized,
            sum(rbs.tel_iloscwyd_sum) AS tel_iloscwyd_sum,
            rbs.tr_idtrans,
            sum(
                CASE
                    WHEN ((rbs.tel_stvat = (0)::numeric) AND (rbs.tel_zw = 4)) THEN 1
                    ELSE 0
                END) AS iloscoo
           FROM (kv_raport_bystawka_odetailed rbs
             JOIN public.tg_transakcje USING (tr_idtrans))
          WHERE (rbs.tel_zaokl = 0)
          GROUP BY rbs.tr_idtrans, tg_transakcje.tr_zamknieta
        UNION
         SELECT 2,
            sum(rbs.tel_netnetto) AS netto,
            sum((rbs.tel_netbrutto - rbs.tel_netnetto)) AS vat,
            sum(rbs.tel_netbrutto) AS brutto,
            0 AS kgonetto,
            0 AS kgovat,
            0 AS kgobrutto,
            sum(rbs.l_pozycji) AS l_pozycji,
            public.nullzero(public.max((0)::numeric, ceil(public.min((1)::numeric, sum(rbs.tel_iloscwyd_sum))))) AS iloscmmized,
            sum(rbs.tel_iloscwyd_sum) AS tel_iloscwyd_sum,
            rbs.tr_idtrans,
            sum(
                CASE
                    WHEN ((rbs.tel_stvat = (0)::numeric) AND (rbs.tel_zw = 4)) THEN 1
                    ELSE 0
                END) AS iloscoo
           FROM (kv_raport_bystawka_odetailed rbs
             JOIN public.tg_transakcje USING (tr_idtrans))
          WHERE (rbs.tel_zaokl <> 0)
          GROUP BY rbs.tr_idtrans, tg_transakcje.tr_zamknieta) t
  GROUP BY t.tr_idtrans;


SET search_path = vendo, pg_catalog;
