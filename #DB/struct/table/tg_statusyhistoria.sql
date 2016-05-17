CREATE TABLE tg_statusyhistoria (
    sh_idstathis integer DEFAULT nextval(('tg_statusyhistoria_s'::text)::regclass) NOT NULL,
    st_idstatusu integer,
    sh_idref integer,
    sh_type integer,
    p_idpracownika integer,
    sh_data timestamp without time zone DEFAULT now(),
    sh_opis text,
    sh_flaga integer,
    sh_aktualny boolean
);
