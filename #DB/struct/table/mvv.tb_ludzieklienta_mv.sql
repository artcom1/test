CREATE TABLE tb_ludzieklienta_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    lk_idczklienta integer NOT NULL
);
