CREATE TABLE tg_zlecenia_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    zl_idzlecenia integer NOT NULL
);
