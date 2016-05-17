CREATE TABLE tg_transakcje_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tr_idtrans integer NOT NULL
);
