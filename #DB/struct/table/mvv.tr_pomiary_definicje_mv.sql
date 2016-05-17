CREATE TABLE tr_pomiary_definicje_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    pd_iddefinicji integer NOT NULL
);
