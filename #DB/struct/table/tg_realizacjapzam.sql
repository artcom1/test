CREATE TABLE tg_realizacjapzam (
    rm_idrealizacji integer DEFAULT nextval(('tg_realizacjapzam_s'::text)::regclass) NOT NULL,
    tel_idpzam integer,
    rm_iloscf numeric DEFAULT 0,
    rm_powod integer DEFAULT 0,
    rm_flaga integer DEFAULT 0,
    tel_idelemsrc integer,
    tr_idtranssrc integer,
    rm_przell numeric DEFAULT 1,
    rm_przelm numeric DEFAULT 1,
    pe_idelemuzam integer,
    p_idpracownika integer,
    pz_idplanu integer,
    tex_idpzam integer,
    rm_iloscfminus numeric DEFAULT 0,
    rm_idtominus integer,
    rm_iloscfnegated numeric,
    rm_iloscfwynik numeric,
    rm_iloscfnadmiar numeric DEFAULT 0 NOT NULL,
    rm_seqno integer
);


SET search_path = bisserwis, pg_catalog;
