CREATE TABLE tb_zlecenia_skojarzone (
    zls_id integer DEFAULT nextval('tb_zlecenia_skojarzone_s'::regclass) NOT NULL,
    zl_idzlecenia_a integer,
    zl_idzlecenia_b integer,
    zls_flag integer DEFAULT 0
);
