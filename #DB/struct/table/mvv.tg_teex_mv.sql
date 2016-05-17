CREATE TABLE tg_teex_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tex_idelem integer NOT NULL
);
