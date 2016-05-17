CREATE VIEW krv_rozliczono AS
 SELECT nullzero(sum((krv_rozliczenia.rl_wartoscplnsrc + krv_rozliczenia.rl_roznicekursowesrc))) AS rozliczono,
    krv_rozliczenia.rr_idrozrachunkusrc AS rr_idrozrachunku
   FROM krv_rozliczenia
  WHERE (krv_rozliczenia.rl_wartoscwalsrc <> (0)::numeric)
  GROUP BY krv_rozliczenia.rr_idrozrachunkusrc;
