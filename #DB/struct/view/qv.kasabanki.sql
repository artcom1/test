CREATE VIEW kasabanki AS
 SELECT pl.pl_idplatnosc AS idplatnosci,
    pl.k_idklienta AS idklienta,
    kl.k_kod AS kodklienta,
    pl.bk_idbanku AS idbankukasy,
    pl.pl_datawplywu AS datawplywu,
    pl.pl_wartosc AS kwotawal,
    pl.wl_idwaluty AS idwaluty,
    public.round(((pl.pl_wartosc)::public.mpq OPERATOR(public.*) pl.wl_przelicznik), 2) AS kwotapln,
    (pl.wl_przelicznik)::numeric AS kurswaluty,
    pl.pl_wplyw AS wplyw,
    pl.pl_opis AS opis
   FROM (public.kh_platnosci pl
     JOIN public.tb_klient kl ON ((kl.k_idklienta = pl.k_idklienta)))
  WHERE ((NOT public.pliskompensata(pl.pl_flaga)) AND (public.pliswplwypl(pl.pl_flaga) OR public.pliscanceled(pl.pl_flaga)));
