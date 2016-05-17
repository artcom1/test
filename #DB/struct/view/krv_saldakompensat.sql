CREATE VIEW krv_saldakompensat AS
 SELECT sum(
        CASE
            WHEN ((rl.rl_flaga & 32) = 32) THEN rl.rl_wartoscwaldst
            ELSE (0)::numeric
        END) AS razem_wn,
    (- sum(
        CASE
            WHEN ((rl.rl_flaga & 32) = 0) THEN rl.rl_wartoscwaldst
            ELSE (0)::numeric
        END)) AS razem_ma,
    rd.rr_idwaluty,
    rr.pl_idplatnosc
   FROM (((krv_rozliczenia rl
     JOIN kr_rozrachunki rr ON ((rr.rr_idrozrachunku = rl.rr_idrozrachunkusrc)))
     JOIN kr_rozrachunki rd ON ((rd.rr_idrozrachunku = rl.rr_idrozrachunkudst)))
     JOIN kh_platnosci pl ON ((rr.pl_idplatnosc = pl.pl_idplatnosc)))
  WHERE (((rr.rr_flaga & 7) = 5) AND (pl.wl_idwaluty = rd.rr_idwaluty))
  GROUP BY rd.rr_idwaluty, rr.pl_idplatnosc;
