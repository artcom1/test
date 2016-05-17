CREATE TABLE tb_rolepdz (
    rpd_id integer DEFAULT nextval('tb_rolepdz_s'::regclass) NOT NULL,
    rol_id integer NOT NULL,
    dz_iddzialu integer NOT NULL,
    p_idpracownika integer NOT NULL,
    rpd_flag integer DEFAULT 0 NOT NULL
);
