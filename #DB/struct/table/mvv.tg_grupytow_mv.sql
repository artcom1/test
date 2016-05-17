CREATE TABLE tg_grupytow_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tgr_idgrupy integer NOT NULL
);
