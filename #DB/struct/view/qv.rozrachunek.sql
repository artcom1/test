CREATE VIEW rozrachunek AS
 SELECT rr.rr_idrozrachunku,
    rr.tr_idtrans,
    rr.rr_idwaluty AS wl_idwaluty,
    rr.k_idklienta AS tr_kidklienta,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_kwotawnwal
            ELSE rr.rr_kwotamawal
        END AS wartoscrozrachunku_waluta,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpln
            ELSE rr.rr_wartoscmapln
        END AS wartoscrozrachunku_pln,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpozwal
            ELSE rr.rr_wartoscmapozwal
        END AS wartoscdorozliczenia_waluta,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpozpln
            ELSE rr.rr_wartoscmapozpln
        END AS wartoscdorozliczenia_pln,
    rr.rr_iswn AS winien,
    rr.rr_dataplatnosci AS terminwymagalnosci,
    rr.rr_formaplat AS pl_formaplat,
    ((rr.rr_flaga & (1 << 14)) <> 0) AS spornysadowy,
    rr.rr_datazaplacenia AS datazaplacenia
   FROM (public.kr_rozrachunki rr
     JOIN public.tg_transakcje tr USING (tr_idtrans))
  WHERE ((rr.tr_idtrans > 0) AND ((rr.rr_flaga & 7) = ANY (ARRAY[0, 3, 5])) AND ((tr.tr_zamknieta & 1) = 1) AND (rr.rr_isnormal = true));
