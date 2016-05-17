CREATE TABLE tb_chatuser (
    ctu_id integer DEFAULT nextval('tb_chatuser_s'::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    ctu_address text,
    ctu_password text,
    ctu_flag integer DEFAULT 0 NOT NULL
);
