CREATE TABLE tg_planzlecenia (
    pz_idplanu integer DEFAULT nextval(('tg_planzlecenia_s'::text)::regclass) NOT NULL,
    zl_idzlecenia integer,
    k_idklienta integer,
    ttw_idtowaru integer,
    ob_idobiektu integer,
    pz_ilosc numeric,
    pz_cena numeric,
    wl_idwaluty integer,
    pz_idref integer,
    pz_flaga integer,
    p_idpracownika integer,
    pz_wartoscprzenies numeric DEFAULT 0,
    pz_kod text,
    pz_lp integer,
    pz_ilosczreal numeric DEFAULT 0,
    pz_opis text,
    tel_idsrcelem integer,
    p_idpracwykon integer,
    pz_iloscroz numeric DEFAULT 0,
    st_idstatusu integer,
    pz_nazwa text,
    pa_idawarii integer DEFAULT 0,
    zd_idzdarzenia integer,
    pz_data timestamp with time zone,
    pz_datado timestamp with time zone,
    pz_przeldoojca numeric DEFAULT 0,
    pz_iloscojciec numeric DEFAULT 0,
    pz_iloscojciecwyk numeric DEFAULT 0,
    pz_iloscojciecplan numeric DEFAULT 0,
    pz_zapotrzebowanieojciec numeric DEFAULT 0,
    pz_dataojca timestamp with time zone,
    sk_idstruktury integer,
    pz_wymiar_x numeric,
    pz_wymiar_y numeric,
    pz_wymiar_z numeric,
    pz_naddatek_x numeric,
    pz_naddatek_y numeric,
    pz_naddatek_z numeric,
    pz_narzut_procent numeric,
    pz_operacja1 integer,
    pz_operacja2 integer,
    pz_operacja3 integer,
    pz_operacja4 integer,
    ttw_idmaterialu integer,
    pz_przebieg numeric DEFAULT 0,
    pz_idrewizja integer,
    pz_idroot integer,
    pz_iloscmat numeric DEFAULT 0,
    pz_ilosczam numeric DEFAULT 0,
    pz_ilosczamdozreal numeric DEFAULT 0,
    pz_newflaga integer DEFAULT 0,
    pz_dataod timestamp with time zone,
    pz_termin timestamp with time zone,
    pz_ilosczrealclosed numeric DEFAULT 0 NOT NULL,
    pz_ilosckartonow numeric DEFAULT 0,
    pz_rmp_idsposobu integer,
    pz_kkw_norma_rbh_wyk numeric DEFAULT 0,
    pz_kkw_norma_rbh_roz numeric DEFAULT 0,
    pz_kkw_norma_mh_wyk numeric DEFAULT 0,
    pz_kkw_norma_mh_roz numeric DEFAULT 0,
    pz_kkw_norma_rbh_wyk_podrz numeric DEFAULT 0,
    pz_kkw_norma_rbh_roz_podrz numeric DEFAULT 0,
    pz_kkw_norma_mh_wyk_podrz numeric DEFAULT 0,
    pz_kkw_norma_mh_roz_podrz numeric DEFAULT 0
);
