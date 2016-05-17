CREATE VIEW rejestracjaprodukcjiwgmaszyn AS
 SELECT wyk.kwe_idelemu AS idnodakkw,
    wyk.ob_idobiektu AS idobiektu,
    public.wylicziloscwykonaniamrp(wyk.knw_iloscwyk, nod.kwe_iloscplanwyk, nod.the_flaga) AS iloscwykonana,
    wyk.knw_iloscbrakow AS iloscbrakow,
    wyk.knw_datastart AS datarozpoczecia,
    wyk.knw_datawyk AS datazakonczenia,
    public.getczaspracystanowiska(wyk.knw_datastart, wyk.knw_datawyk, wyk.knw_flaga) AS czaspracystanowiska,
    public.getnormatywstanowiska(public.wylicziloscwykonaniamrp(wyk.knw_iloscwyk, nod.kwe_iloscplanwyk, nod.the_flaga), wyk.knw_tpj, wyk.knw_tpz, wyk.knw_wydajnosc) AS normatywwykonania,
    wyk.knw_tpz AS normatyw_tpz,
    wyk.knw_tpj AS normatywn_tpj,
    wyk.knw_wydajnosc AS normatyw_wydajnosc,
    wyk.knw_iloscosob AS normatyw_iloscosob,
    wyk.knw_kosztnaj AS normatyw_kosznaj,
    wyk.knw_kosztnah AS normatywn_kosztnah,
    wyk.knw_uwagi AS wykonaniekkwuwagi,
    wyk.tsw_idslownika AS wykonanieslownik,
    (wyk.knw_czaswolny + wyk.knw_czaswolny_wd) AS wykonanieczaswolny,
    (wyk.knw_czaswolny_np + wyk.knw_czaswolny_np_wd) AS wykonanieczaswolnynieplanowany,
    public.getczaspracystanowiskadlaoee(wyk.knw_idelemu, wyk.knw_datastart, wyk.knw_datawyk, wyk.knw_flaga) AS czaspracystanowiskadlaoee
   FROM (public.tr_kkwnodwyk wyk
     JOIN public.tr_kkwnod nod USING (kwe_idelemu));
