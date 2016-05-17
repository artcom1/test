CREATE VIEW kv_docvat AS
 SELECT
        CASE
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum((rbs.tel_brutto - rbs.tel_vatb))
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum((rbs.tel_brutto - rbs.tel_vatb2))
            ELSE sum(rbs.tel_netto)
        END AS netto,
        CASE
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN sum(rbs.tel_vatb)
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN sum(rbs.tel_vatb2)
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (1 << 17)) THEN sum(rbs.tel_vat2)
            ELSE sum(rbs.tel_vat)
        END AS vat,
        CASE
            WHEN ((tr.tr_zamknieta & 128) = 128) THEN sum(rbs.tel_brutto)
            WHEN ((tr.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN sum((rbs.tel_netto + rbs.tel_vat2))
            ELSE sum((rbs.tel_netto + rbs.tel_vat))
        END AS brutto,
    sum(rbs.l_pozycji) AS l_pozycji,
    public.nullzero(public.max((0)::numeric, ceil(public.min((1)::numeric, sum(rbs.tel_iloscwyd_sum))))) AS iloscmmized,
    sum(rbs.tel_iloscwyd_sum) AS tel_iloscwyd_sum,
    rbs.tr_idtrans,
    rbs.isorg,
    rbs.iswal,
    COALESCE(rbs.tel_waluta, tr.wl_idwaluty) AS tel_waluta
   FROM (kv_docbystawka rbs
     JOIN public.tg_transakcje tr USING (tr_idtrans))
  GROUP BY rbs.tr_idtrans, tr.tr_zamknieta, rbs.isorg, rbs.iswal, COALESCE(rbs.tel_waluta, tr.wl_idwaluty);
