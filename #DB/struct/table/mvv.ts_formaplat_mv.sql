CREATE TABLE ts_formaplat_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    pl_formaplat integer NOT NULL,
    pl_value7 text,
    pl_value7_flag integer
);
