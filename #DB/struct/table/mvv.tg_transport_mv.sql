CREATE TABLE tg_transport_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    lt_idtransportu integer NOT NULL
);
