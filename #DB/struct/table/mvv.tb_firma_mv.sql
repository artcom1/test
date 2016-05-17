CREATE TABLE tb_firma_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    fm_index integer NOT NULL
);
