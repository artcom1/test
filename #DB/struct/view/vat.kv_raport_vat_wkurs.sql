CREATE VIEW kv_raport_vat_wkurs AS
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
    sum(t.v_iloscwyd_sum) AS v_iloscwyd_sum,
    sum(t.iloscoo) AS iloscoo,
    sum(t.l_pozycji0) AS l_pozycji0,
    sum(t.l_pozycjiusl) AS l_pozycjiusl,
    t.v_kursdok,
    (max((t.odbrutto)::integer))::boolean AS odbrutto,
    t.ispkorkurs
   FROM ( SELECT 1,
                CASE
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum((rbs.v_brutto - rbs.v_vatb))
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum((rbs.v_brutto - rbs.v_vatb2))
                    ELSE sum(rbs.v_netto)
                END AS netto,
                CASE
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum(rbs.v_vatb)
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum(rbs.v_vatb2)
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (1 << 17)) THEN sum(rbs.v_vat2)
                    ELSE sum(rbs.v_vat)
                END AS vat,
                CASE
                    WHEN ((tr.tr_zamknieta & 128) = 128) THEN sum(rbs.v_brutto)
                    WHEN ((tr.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN sum((rbs.v_netto + rbs.v_vat2))
                    ELSE sum((rbs.v_netto + rbs.v_vat))
                END AS brutto,
                CASE
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum((rbs.v_netbrutto - rbs.v_netvatb))
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum((rbs.v_netbrutto - rbs.v_netvatb2))
                    ELSE sum(rbs.v_netnetto)
                END AS netnetto,
                CASE
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum(rbs.v_netvatb)
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum(rbs.v_netvatb2)
                    WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (1 << 17)) THEN sum(rbs.v_netvat2)
                    ELSE sum(rbs.v_netvat)
                END AS netvat,
                CASE
                    WHEN ((tr.tr_zamknieta & 128) = 128) THEN sum(rbs.v_netbrutto)
                    WHEN ((tr.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN sum((rbs.v_netnetto + rbs.v_netvat2))
                    ELSE sum((rbs.v_netnetto + rbs.v_netvat))
                END AS netbrutto,
            sum(rbs.l_pozycji) AS l_pozycji,
            sum(rbs.l_pozycji0) AS l_pozycji0,
            sum(rbs.l_pozycjiusl) AS l_pozycjiusl,
            sum(rbs.v_iloscwyd_sum) AS v_iloscwyd_sum,
            rbs.tr_idtrans,
            sum(
                CASE
                    WHEN ((rbs.v_stvat = (0)::numeric) AND (rbs.v_zw = 4)) THEN rbs.l_pozycji
                    ELSE (0)::numeric
                END) AS iloscoo,
            rbs.v_kursdok,
                CASE
                    WHEN ((tr.tr_zamknieta & 128) = 128) THEN true
                    ELSE false
                END AS odbrutto,
                CASE
                    WHEN (rbs.v_kursdok OPERATOR(public.=) tr.tr_przelicznik) THEN 0
                    ELSE 1
                END AS ispkorkurs
           FROM (kv_raport_bystawka_detailed rbs
             JOIN public.tg_transakcje tr USING (tr_idtrans))
          WHERE ((rbs.v_iswal = false) AND (rbs.v_zaokl = false))
          GROUP BY rbs.tr_idtrans, tr.tr_zamknieta, rbs.v_kursdok, tr.tr_przelicznik
        UNION
         SELECT 2,
            sum(rbs.v_netto) AS netto,
            sum((rbs.v_brutto - rbs.v_netto)) AS vat,
            sum(rbs.v_brutto) AS brutto,
            0 AS kgonetto,
            0 AS kgovat,
            0 AS kgobrutto,
            sum(rbs.l_pozycji) AS l_pozycji,
            0 AS l_pozycji0,
            0 AS l_pozycjiusl,
            sum(rbs.v_iloscwyd_sum) AS v_iloscwyd_sum,
            rbs.tr_idtrans,
            sum(
                CASE
                    WHEN ((rbs.v_stvat = (0)::numeric) AND (rbs.v_zw = 4)) THEN rbs.l_pozycji
                    ELSE (0)::numeric
                END) AS iloscoo,
            rbs.v_kursdok,
                CASE
                    WHEN ((tr.tr_zamknieta & 128) = 128) THEN true
                    ELSE false
                END AS odbrutto,
                CASE
                    WHEN (rbs.v_kursdok OPERATOR(public.=) tr.tr_przelicznik) THEN 0
                    ELSE 1
                END AS ispkorkurs
           FROM (kv_raport_bystawka_detailed rbs
             JOIN public.tg_transakcje tr USING (tr_idtrans))
          WHERE ((rbs.v_iswal = false) AND (rbs.v_zaokl = true))
          GROUP BY rbs.tr_idtrans, tr.tr_zamknieta, rbs.v_kursdok, tr.tr_przelicznik) t
  GROUP BY t.tr_idtrans, t.v_kursdok, t.ispkorkurs;
