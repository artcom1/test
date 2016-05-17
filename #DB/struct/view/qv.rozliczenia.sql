CREATE VIEW rozliczenia AS
 SELECT krv_rozliczenia.rl_idrozliczenia AS idrozliczenia,
    krv_rozliczenia.rr_idrozrachunkusrc AS rr_idrozrachunku,
    krv_rozliczenia.rr_idrozrachunkudst AS rd_iddanerozrachunkuprawa,
        CASE
            WHEN (kr_rozrachunki.rr_iswn = false) THEN (- krv_rozliczenia.rl_wartoscwalsrc)
            ELSE krv_rozliczenia.rl_wartoscwalsrc
        END AS wartoscrozliczenia_waluta,
        CASE
            WHEN (kr_rozrachunki.rr_iswn = false) THEN (- krv_rozliczenia.rl_wartoscplnsrc)
            ELSE krv_rozliczenia.rl_wartoscplnsrc
        END AS wartoscrozliczenia_pln,
    krv_rozliczenia.rl_datarozliczenia AS dataoperacjirozliczenia,
    krv_rozliczenia.rl_roznicekursowesrc AS roznicakursowa_rozliczenia,
    ((kr_rozrachunki.rr_flaga & (1 << 14)) <> 0) AS spornysadowy
   FROM ((public.krv_rozliczenia
     JOIN public.kr_rozrachunki ON ((kr_rozrachunki.rr_idrozrachunku = krv_rozliczenia.rr_idrozrachunkusrc)))
     JOIN public.tg_transakcje tr USING (tr_idtrans))
  WHERE ((kr_rozrachunki.tr_idtrans > 0) AND ((kr_rozrachunki.rr_flaga & 7) = ANY (ARRAY[0, 3, 5])) AND ((tr.tr_zamknieta & 1) = 1))
UNION
 SELECT (- rr.rr_idrozrachunku) AS idrozliczenia,
    rr.rr_idrozrachunku,
    NULL::integer AS rd_iddanerozrachunkuprawa,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpozwal
            ELSE rr.rr_wartoscmapozwal
        END AS wartoscrozliczenia_waluta,
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpozpln
            ELSE rr.rr_wartoscmapozpln
        END AS wartoscrozliczenia_pln,
    NULL::date AS dataoperacjirozliczenia,
    0 AS roznicakursowa_rozliczenia,
    ((rr.rr_flaga & (1 << 14)) <> 0) AS spornysadowy
   FROM (public.kr_rozrachunki rr
     JOIN public.tg_transakcje tr USING (tr_idtrans))
  WHERE ((
        CASE
            WHEN (rr.rr_iswn = true) THEN rr.rr_wartoscwnpozwal
            ELSE rr.rr_wartoscmapozwal
        END <> (0)::numeric) AND (rr.tr_idtrans > 0) AND ((rr.rr_flaga & 7) = ANY (ARRAY[0, 3, 5])) AND ((tr.tr_zamknieta & 1) = 1));
