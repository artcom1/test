CREATE TABLE tg_pphead (
    pph_idheadu integer DEFAULT nextval('tg_transelem_s'::regclass) NOT NULL,
    tr_idtrans integer NOT NULL,
    ttw_idtowarundx integer NOT NULL
);
