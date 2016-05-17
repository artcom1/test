CREATE TABLE tg_ppelem (
    ppe_idelemu integer DEFAULT nextval('tg_transelem_s'::regclass) NOT NULL,
    tr_idtrans integer NOT NULL,
    tel_idelem_minus integer NOT NULL,
    tel_idelem_plus integer,
    ttw_idtowaru integer NOT NULL,
    ppe_iloscf numeric NOT NULL,
    prt_idpartii_minus integer NOT NULL,
    prt_idpartii_plus integer,
    ppe_flaga integer DEFAULT 0 NOT NULL,
    ppe_newwartosc numeric,
    phe_ref_minus integer,
    phe_ref_plus integer
);
