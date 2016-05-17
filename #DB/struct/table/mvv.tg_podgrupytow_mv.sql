CREATE TABLE tg_podgrupytow_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tpg_idpodgrupy integer NOT NULL
);
