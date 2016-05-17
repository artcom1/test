CREATE TABLE tg_elslownika_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    es_idelem integer NOT NULL
);
