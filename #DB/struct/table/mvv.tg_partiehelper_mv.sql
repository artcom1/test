CREATE TABLE tg_partiehelper_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    prh_idpartii integer NOT NULL
);
