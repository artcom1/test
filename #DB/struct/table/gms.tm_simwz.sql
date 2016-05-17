CREATE TABLE tm_simwz (
    swz_id integer DEFAULT nextval('tm_simwz_s'::regclass) NOT NULL,
    sc_id integer NOT NULL,
    rc_idruchupz integer NOT NULL,
    rc_idruchuwz integer NOT NULL,
    prt_idpartiipz integer NOT NULL,
    mm_idmiejscapz integer,
    swz_iloscrest_pnull numeric DEFAULT 0 NOT NULL,
    swz_iloscrest_p numeric DEFAULT 0 NOT NULL,
    swz_iloscpozondel numeric DEFAULT 0,
    swz_iloscpriorondel numeric DEFAULT 0,
    tr_idtrans integer
);
