CREATE TABLE tr_pracownicykubelka (
    pk_idprac integer DEFAULT nextval('tr_zmiany_s'::regclass) NOT NULL,
    kb_idkubelka integer,
    p_idpracownika integer,
    pk_iloscrbh numeric
);
