CREATE TABLE tg_dostawaelem (
    de_idelemu integer DEFAULT nextval('tg_dostawaelem_s'::regclass) NOT NULL,
    dw_iddostawy integer NOT NULL,
    tr_idtrans integer,
    pk_idpaczki integer,
    de_flaga integer DEFAULT 0
);
