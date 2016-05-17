CREATE TABLE tr_ciagtech_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    ct_idciagu integer NOT NULL
);
