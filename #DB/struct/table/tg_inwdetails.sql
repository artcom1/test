CREATE TABLE tg_inwdetails (
    ind_id integer DEFAULT nextval('tg_transelem_s'::regclass) NOT NULL,
    ine_id integer NOT NULL,
    tr_idtrans integer NOT NULL,
    mm_idmiejsca integer,
    prt_idpartiipz integer NOT NULL,
    ttw_idtowaru integer NOT NULL,
    ind_iloscf_calc numeric NOT NULL,
    ind_iloscf numeric NOT NULL,
    ind_isinbuf boolean NOT NULL,
    ind_iloscfmoved numeric DEFAULT 0 NOT NULL,
    ind_updatecounter integer DEFAULT nextval('tg_inwdetails_upd'::regclass) NOT NULL,
    ind_versioncounter integer DEFAULT nextval('tg_inwdetails_upd'::regclass) NOT NULL
);
