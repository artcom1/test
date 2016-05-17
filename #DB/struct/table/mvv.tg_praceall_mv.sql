CREATE TABLE tg_praceall_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    pra_idpracy integer NOT NULL
);
