CREATE VIEW kv_raport_stawki AS
 SELECT t.tr_idtrans,
    sum(t.netto) AS netto,
    sum(t.vat) AS vat,
    sum(t.brutto) AS brutto,
    t.stawka
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
                    WHEN ((tg_transakcje.tr_zamknieta & 128) <> 0) THEN rbs.tel_brutto
                    WHEN ((tg_transakcje.tr_zamknieta & (1 << 17)) = (1 << 17)) THEN (rbs.tel_netto + rbs.tel_vat2)
                    ELSE (rbs.tel_netto + rbs.tel_vat)
                END AS brutto,
                CASE
                    WHEN (rbs.tel_stvat <> (0)::numeric) THEN (rbs.tel_stvat)::text
                    WHEN ((tg_transakcje.tr_sprzedaz < 0) AND ((rbs.tel_zw & 1) <> 0)) THEN 'ZW'::text
                    WHEN ((tg_transakcje.tr_sprzedaz >= 0) AND ((rbs.tel_zw & 2) <> 0)) THEN 'ZW'::text
                    ELSE '0'::text
                END AS stawka,
            rbs.tr_idtrans
           FROM (kv_raport_bystawka rbs
             JOIN public.tg_transakcje USING (tr_idtrans))
          WHERE (rbs.tel_zaokl = 0)
        UNION
         SELECT 2,
            rbs.tel_netto AS netto,
            (rbs.tel_brutto - rbs.tel_netto) AS vat,
            rbs.tel_brutto AS brutto,
                CASE
                    WHEN (rbs.tel_stvat <> (0)::numeric) THEN (rbs.tel_stvat)::text
                    WHEN ((tg_transakcje.tr_sprzedaz < 0) AND ((rbs.tel_zw & 1) <> 0)) THEN 'ZW'::text
                    WHEN ((tg_transakcje.tr_sprzedaz >= 0) AND ((rbs.tel_zw & 2) <> 0)) THEN 'ZW'::text
                    ELSE '0'::text
                END AS stawka,
            rbs.tr_idtrans
           FROM (kv_raport_bystawka rbs
             JOIN public.tg_transakcje USING (tr_idtrans))
          WHERE (rbs.tel_zaokl <> 0)) t
  GROUP BY t.tr_idtrans, t.stawka;
