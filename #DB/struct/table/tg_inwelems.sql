CREATE TABLE tg_inwelems (
    ine_id integer DEFAULT nextval('tg_transelem_s'::regclass) NOT NULL,
    tr_idtrans integer NOT NULL,
    mm_idmiejsca integer,
    ine_isinbuf boolean NOT NULL
);
