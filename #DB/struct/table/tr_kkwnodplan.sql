CREATE TABLE tr_kkwnodplan (
    knp_idplanu integer DEFAULT nextval(('tr_kkwnodplan_s'::text)::regclass) NOT NULL,
    kwe_idelemu integer,
    kwh_idheadu integer,
    ob_idobiektu integer,
    knp_datarozpoczecia timestamp without time zone,
    knp_datazakonczenia timestamp without time zone,
    knp_iloscplanowana numeric DEFAULT 0,
    knp_iloscwykonana numeric DEFAULT 0,
    knp_flaga integer,
    knp_czaswolny numeric DEFAULT 0,
    knp_czasnormapozostalo numeric DEFAULT 0,
    kb_idkubelka integer,
    st_idstatusu integer,
    knp_czaswolny_np numeric DEFAULT 0
);
