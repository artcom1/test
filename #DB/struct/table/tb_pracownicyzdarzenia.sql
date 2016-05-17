CREATE TABLE tb_pracownicyzdarzenia (
    pzd_idpracownika integer DEFAULT nextval(('tb_pracownicyzdarzenia_s'::text)::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    zd_idzdarzenia integer NOT NULL,
    pzd_flaga integer DEFAULT 0,
    pzd_opis text,
    pzd_polecenie text
);
