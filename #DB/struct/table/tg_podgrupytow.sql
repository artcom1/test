CREATE TABLE tg_podgrupytow (
    tpg_idpodgrupy integer DEFAULT nextval(('tg_podgrupy_s'::text)::regclass) NOT NULL,
    tpg_nazwa text,
    tpg_flaga integer DEFAULT 1,
    tpg_parent integer,
    tpg_l integer,
    tpg_r integer,
    tpg_sciezka text
);
