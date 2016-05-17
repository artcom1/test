CREATE VIEW kv_raport_bystawka_ret AS
 SELECT sum(t.netto) AS netto,
    sum(t.vat) AS vat,
    sum(t.brutto) AS brutto,
    t.tel_stvat,
    t.tel_zw,
    sum(t.tel_iloscwyd_sum) AS tel_iloscwyd_sum,
    sum(t.l_pozycji) AS l_pozycji,
    t.tr_idtrans
   FROM ( SELECT 1,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = 128) THEN (rbs.tel_brutto - rbs.tel_vatb)
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN (rbs.tel_brutto - rbs.tel_vatb2)
                    ELSE rbs.tel_netto
                END AS netto,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = 128) THEN rbs.tel_vatb
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN rbs.tel_vatb2
                    WHEN ((tg_transakcje.tr_zamknieta & (128 | (1 << 17))) = (1 << 17)) THEN rbs.tel_vat2
                    ELSE rbs.tel_vat
                END AS vat,
                CASE
                    WHEN ((tg_transakcje.tr_zamknieta & 128) = 128) THEN rbs.tel_brutto
                    WHEN ((tg_transakcje.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN (rbs.tel_netto + rbs.tel_vat2)
                    ELSE (rbs.tel_netto + rbs.tel_vat)
                END AS brutto,
            rbs.tel_stvat,
            (rbs.tel_zw & 7) AS tel_zw,
            rbs.tel_iloscwyd_sum,
            rbs.l_pozycji,
            rbs.tr_idtrans
           FROM (kv_raport_bystawka rbs
             JOIN public.tg_transakcje USING (tr_idtrans))
          WHERE (rbs.tel_zaokl = 0)
        UNION
         SELECT 2,
            rbs.tel_netto AS netto,
            (rbs.tel_brutto - rbs.tel_netto) AS vat,
            rbs.tel_brutto AS brutto,
            rbs.tel_stvat,
            (rbs.tel_zw & 7) AS tel_zw,
            rbs.tel_iloscwyd_sum,
            rbs.l_pozycji,
            rbs.tr_idtrans
           FROM (kv_raport_bystawka rbs
             JOIN public.tg_transakcje USING (tr_idtrans))
          WHERE (rbs.tel_zaokl <> 0)) t
  GROUP BY t.tr_idtrans, t.tel_stvat, t.tel_zw;
