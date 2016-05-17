CREATE TABLE tb_klient_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    k_idklienta integer NOT NULL
);
