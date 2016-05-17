CREATE TABLE tr_rrozchodu (
    trr_idelemu integer DEFAULT nextval(('tr_rrozchodu_s'::text)::regclass) NOT NULL,
    ttw_idtowaru integer,
    th_idtechnologii integer,
    the_idelem integer,
    tmg_idmagazynu integer,
    trr_iloscl numeric DEFAULT 0,
    trr_iloscm numeric DEFAULT 0,
    trr_flaga integer DEFAULT 0,
    trr_wplywmag integer DEFAULT '-1'::integer,
    ja_idjednostki integer,
    st_idstatusu integer,
    ob_idobiektu integer,
    trr_ilosclalt numeric DEFAULT 0,
    trr_cena numeric DEFAULT 0,
    trr_kod text,
    trr_iloscmin numeric DEFAULT 0,
    trr_lp integer DEFAULT 0,
    trr_wymiar_x numeric DEFAULT 0,
    trr_wymiar_y numeric DEFAULT 0,
    trr_wymiar_z numeric DEFAULT 0,
    trr_iloscprzel numeric DEFAULT 0,
    trr_narzut_procent numeric DEFAULT 0,
    trr_idparent integer,
    trr_rozmiarwyst numeric[],
    trr_opis text,
    trr_ilosckrotnosc numeric DEFAULT 1,
    trr_przebieg_a_l numeric DEFAULT 1,
    trr_przebieg_a_m numeric DEFAULT 1,
    trr_przebieg_b numeric DEFAULT 0,
    trr_magnarzedzityp integer DEFAULT 0,
    trr_kosztstaly numeric DEFAULT 0
);