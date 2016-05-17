CREATE TABLE tb_masspayment (
    mp_idmp integer DEFAULT nextval('tb_masspayment_s'::regclass) NOT NULL,
    bk_idbanku integer NOT NULL,
    mp_nazwa text,
    mp_schemat text,
    mp_nrfunction text
);
