CREATE VIEW krv_checkrozliczono AS
 SELECT kr_rozrachunki.rr_idrozrachunku,
    kr_rozrachunki.rr_wartoscpln,
    kr_rozrachunki.rr_wartoscpozpln,
    (kr_rozrachunki.rr_wartoscpln - kr_rozrachunki.rr_wartoscpozpln) AS jest,
    nullzero(( SELECT r.rozliczono
           FROM krv_rozliczono r
          WHERE (r.rr_idrozrachunku = kr_rozrachunki.rr_idrozrachunku))) AS powinno
   FROM kr_rozrachunki
  WHERE (((kr_rozrachunki.rr_wartoscpln - kr_rozrachunki.rr_wartoscpozpln) <> nullzero(( SELECT r.rozliczono
           FROM krv_rozliczono r
          WHERE (r.rr_idrozrachunku = kr_rozrachunki.rr_idrozrachunku)))) AND (kr_rozrachunki.rr_kwotawal <> (0)::numeric));
