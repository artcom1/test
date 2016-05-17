CREATE TABLE tg_wmsmmruch (
    wmr_idelem integer DEFAULT nextval('tg_transelem_s'::regclass) NOT NULL,
    wmm_idelem integer NOT NULL,
    tr_idtrans integer NOT NULL,
    ttm_idtowmag integer NOT NULL,
    ttw_idtowaru integer,
    wmr_kierunek integer NOT NULL,
    mm_idmiejsca integer,
    wmr_iloscf numeric DEFAULT 0,
    wmr_iloscfw numeric DEFAULT 0,
    prt_idpartiipz integer,
    wmr_iloscfwonempty numeric DEFAULT 0,
    wmr_nullmmeqdowolne boolean DEFAULT false
);
