CREATE TABLE tb_biometricdata (
    bmd_id integer DEFAULT nextval('tb_biometricdata_s'::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    bmd_methodcode text,
    bmd_data text
);
