CREATE VIEW krv_rozliczenia AS
 SELECT krv_rozliczenial.rl_idrozliczenia,
    krv_rozliczenial.rr_idrozrachunkusrc,
    krv_rozliczenial.rr_idrozrachunkudst,
    krv_rozliczenial.rl_wartoscwalsrc,
    krv_rozliczenial.rl_wartoscwaldst,
    krv_rozliczenial.rl_wartoscplnsrc,
    krv_rozliczenial.rl_wartoscplndst,
    krv_rozliczenial.rl_datarozliczenia,
    krv_rozliczenial.rl_datamax,
    krv_rozliczenial.rl_roznicekursowesrc,
    krv_rozliczenial.rl_roznicekursowedst,
    krv_rozliczenial.p_idpracownika,
    krv_rozliczenial.rl_rozliczenieserial,
    krv_rozliczenial.rl_idrozliczenia_rk,
    krv_rozliczenial.rl_flaga
   FROM krv_rozliczenial
UNION ALL
 SELECT krv_rozliczeniar.rl_idrozliczenia,
    krv_rozliczeniar.rr_idrozrachunkusrc,
    krv_rozliczeniar.rr_idrozrachunkudst,
    krv_rozliczeniar.rl_wartoscwalsrc,
    krv_rozliczeniar.rl_wartoscwaldst,
    krv_rozliczeniar.rl_wartoscplnsrc,
    krv_rozliczeniar.rl_wartoscplndst,
    krv_rozliczeniar.rl_datarozliczenia,
    krv_rozliczeniar.rl_datamax,
    krv_rozliczeniar.rl_roznicekursowesrc,
    krv_rozliczeniar.rl_roznicekursowedst,
    krv_rozliczeniar.p_idpracownika,
    krv_rozliczeniar.rl_rozliczenieserial,
    krv_rozliczeniar.rl_idrozliczenia_rk,
    krv_rozliczeniar.rl_flaga
   FROM krv_rozliczeniar;
