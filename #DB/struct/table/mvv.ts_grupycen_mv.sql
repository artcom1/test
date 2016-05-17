CREATE TABLE ts_grupycen_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tgc_idgrupy integer NOT NULL
);
