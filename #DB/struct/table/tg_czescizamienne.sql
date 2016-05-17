CREATE TABLE tg_czescizamienne (
    cz_idczesci integer DEFAULT nextval('tg_czescizamienne_s'::regclass) NOT NULL,
    ttw_idtowarusrc integer,
    ttw_idtowaru integer,
    cz_ilosc numeric,
    cz_flaga integer DEFAULT 0,
    cz_zywotnosc numeric
);
