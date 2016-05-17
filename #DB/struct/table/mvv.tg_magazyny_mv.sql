CREATE TABLE tg_magazyny_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tmg_idmagazynu integer NOT NULL
);
