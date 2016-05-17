CREATE TABLE tg_planzlecenia_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    pz_idplanu integer NOT NULL
);
