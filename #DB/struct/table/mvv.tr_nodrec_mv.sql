CREATE TABLE tr_nodrec_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    knr_idelemu integer NOT NULL
);
