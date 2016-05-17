CREATE TABLE tb_signparams (
    sprms_id integer DEFAULT nextval('tb_signparams_s'::regclass) NOT NULL,
    p_idpracownika integer,
    sprms_prms text
);
