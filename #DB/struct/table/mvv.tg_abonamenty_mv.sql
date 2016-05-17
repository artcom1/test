CREATE TABLE tg_abonamenty_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    ab_idabonamentu integer NOT NULL
);
