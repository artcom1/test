CREATE TABLE tg_partie_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    prt_idpartii integer NOT NULL
);
