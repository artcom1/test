CREATE TABLE tg_transelem_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tel_idelem integer NOT NULL
);
