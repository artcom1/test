CREATE TABLE tp_kkwplan (
    kwp_idplanu integer DEFAULT nextval(('tp_kkwplan_s'::text)::regclass) NOT NULL,
    kwp_data date DEFAULT now(),
    pp_idpolproduktu integer,
    zl_idzlecenia integer,
    kwp_iloscplan numeric DEFAULT 0,
    kwp_ilosczr numeric DEFAULT 0,
    kwp_flaga integer DEFAULT 0,
    kwp_nrzmiany integer,
    p_idpracownika integer,
    kwp_iloscrozp numeric DEFAULT 0,
    kwp_iloscwreal numeric DEFAULT 0,
    kwp_iloscwmag numeric DEFAULT 0,
    pz_idplanu integer,
    kwp_dataend date DEFAULT now()
);
