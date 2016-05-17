CREATE TABLE tb_pracownicyzlecenia (
    pzl_id integer DEFAULT nextval('tb_pracownicyzlecenia_s'::regclass) NOT NULL,
    p_idpracownika integer,
    zl_idzlecenia integer,
    pzl_flag integer DEFAULT 0,
    pzl_flaga integer DEFAULT 0,
    dz_iddzialu integer
);
