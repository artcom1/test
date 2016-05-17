CREATE TABLE tg_swiadectwa_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    sw_idswiadectwa integer NOT NULL
);
