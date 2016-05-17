CREATE TABLE ts_banki_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    bk_idbanku integer NOT NULL
);
