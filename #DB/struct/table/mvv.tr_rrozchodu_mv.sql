CREATE TABLE tr_rrozchodu_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    trr_idelemu integer NOT NULL
);
