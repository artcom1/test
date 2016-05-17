CREATE TABLE tb_ftpuser (
    ftu_iduser integer DEFAULT nextval('tb_ftpuser_s'::regclass) NOT NULL,
    fth_idhost integer,
    ftu_login text,
    ftu_password text,
    p_idpracownika integer
);
