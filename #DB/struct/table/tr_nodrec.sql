CREATE TABLE tr_nodrec (
    knr_idelemu integer DEFAULT nextval(('tr_nodrec_s'::text)::regclass) NOT NULL,
    ttw_idtowaru integer,
    trr_idelemu integer,
    kwe_idelemu integer,
    kwh_idheadu integer,
    tmg_idmagazynu integer,
    knr_licznik numeric DEFAULT 0,
    knr_mianownik numeric DEFAULT 0,
    trr_flaga integer DEFAULT 0,
    knr_iloscplan numeric DEFAULT 0,
    knr_iloscwyk numeric DEFAULT 0,
    knr_iloscrozch numeric DEFAULT 0,
    knr_flaga integer DEFAULT 0,
    ttm_idtowmag integer,
    knr_wplywmag integer,
    knr_ilosczam numeric DEFAULT 0,
    st_idstatusu integer,
    knr_ilosc_plan_rozplan numeric DEFAULT 0,
    knr_ilosc_plan_wyk numeric DEFAULT 0,
    ob_idobiektu integer,
    knr_kod text,
    knr_iloscmin numeric DEFAULT 0,
    knr_lp integer DEFAULT 0,
    knr_wymiar_x numeric DEFAULT 0,
    knr_wymiar_y numeric DEFAULT 0,
    knr_wymiar_z numeric DEFAULT 0,
    knr_iloscprzel numeric DEFAULT 0,
    knr_narzut_procent numeric DEFAULT 0,
    knr_idparent integer,
    knr_ilosckrotnosc numeric DEFAULT 1,
    knr_iloscdysp numeric DEFAULT 0,
    knr_opis text,
    knr_przebieg_a_l numeric DEFAULT 1,
    knr_przebieg_a_m numeric DEFAULT 1,
    knr_przebieg_b numeric DEFAULT 0,
    knr_magnarzedzityp integer DEFAULT 0,
    knr_iloscnarz_plus numeric DEFAULT 0,
    knr_iloscnarz_minus numeric DEFAULT 0
);
