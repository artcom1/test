CREATE TABLE tb_pracownicy_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    p_idpracownika integer NOT NULL
);
