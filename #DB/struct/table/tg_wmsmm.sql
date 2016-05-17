CREATE TABLE tg_wmsmm (
    wmm_idelem integer DEFAULT nextval('tg_transelem_s'::regclass) NOT NULL,
    tr_idtrans integer NOT NULL,
    ttm_idtowmag integer NOT NULL,
    ttw_idtowaru integer,
    wmm_iloscfsrc numeric DEFAULT 0,
    wmm_iloscfsrcw numeric DEFAULT 0,
    wmm_iloscfdst numeric DEFAULT 0,
    wmm_iloscfdstw numeric DEFAULT 0,
    wmm_lp integer
);
