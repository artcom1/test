CREATE VIEW krv_rozliczeniar AS
 SELECT kr_rozliczenia.rl_idrozliczenia,
    kr_rozliczenia.rr_idrozrachunkur AS rr_idrozrachunkusrc,
    kr_rozliczenia.rr_idrozrachunkul AS rr_idrozrachunkudst,
    kr_rozliczenia.rl_wartoscwalr AS rl_wartoscwalsrc,
    kr_rozliczenia.rl_wartoscwall AS rl_wartoscwaldst,
    kr_rozliczenia.rl_wartoscplnr AS rl_wartoscplnsrc,
    kr_rozliczenia.rl_wartoscplnl AS rl_wartoscplndst,
    kr_rozliczenia.rl_datarozliczenia,
    kr_rozliczenia.rl_datamax,
    kr_rozliczenia.rl_roznicekursower AS rl_roznicekursowesrc,
    kr_rozliczenia.rl_roznicekursowel AS rl_roznicekursowedst,
    kr_rozliczenia.p_idpracownika,
    kr_rozliczenia.rl_rozliczenieserial,
    kr_rozliczenia.rl_idrozliczenia_rk,
    (((((((kr_rozliczenia.rl_flaga & 2) >> 1) | ((kr_rozliczenia.rl_flaga & 1) << 1)) | ((kr_rozliczenia.rl_flaga & 8) >> 1)) | ((kr_rozliczenia.rl_flaga & 4) << 1)) | ((kr_rozliczenia.rl_flaga & 32) >> 1)) | ((kr_rozliczenia.rl_flaga & 16) << 1)) AS rl_flaga
   FROM kr_rozliczenia;
