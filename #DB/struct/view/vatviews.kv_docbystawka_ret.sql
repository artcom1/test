CREATE VIEW kv_docbystawka_ret AS
 SELECT
        CASE
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN (rbs.tel_brutto - rbs.tel_vatb)
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN (rbs.tel_brutto - rbs.tel_vatb2)
            ELSE rbs.tel_netto
        END AS netto,
        CASE
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = 128) THEN rbs.tel_vatb
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17))) THEN rbs.tel_vatb2
            WHEN ((tr.tr_zamknieta & (128 | (1 << 17))) = (1 << 17)) THEN rbs.tel_vat2
            ELSE rbs.tel_vat
        END AS vat,
        CASE
            WHEN ((tr.tr_zamknieta & 128) = 128) THEN rbs.tel_brutto
            WHEN ((tr.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN (rbs.tel_netto + rbs.tel_vat2)
            ELSE (rbs.tel_netto + rbs.tel_vat)
        END AS brutto,
    rbs.tel_stvat,
    rbs.tel_zw,
    rbs.tel_iloscwyd_sum,
    rbs.l_pozycji,
    rbs.tr_idtrans,
    rbs.isorg,
    rbs.iswal,
    COALESCE(rbs.tel_waluta, tr.wl_idwaluty) AS tel_waluta
   FROM (kv_docbystawka rbs
     JOIN public.tg_transakcje tr USING (tr_idtrans));
