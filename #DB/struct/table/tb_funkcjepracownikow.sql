CREATE TABLE tb_funkcjepracownikow (
    fp_idfunprac integer DEFAULT nextval('tb_funkcjepracownikow_s'::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    fp_funkcja integer
);
