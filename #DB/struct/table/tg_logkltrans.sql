CREATE TABLE tg_logkltrans (
    lkt_idpowiazania integer DEFAULT nextval('tg_logkltrans_s'::regclass) NOT NULL,
    kl_idklientalog integer NOT NULL,
    tr_idtrans integer NOT NULL
);
