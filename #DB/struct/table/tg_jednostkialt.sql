CREATE TABLE tg_jednostkialt (
    ja_idjednostki integer DEFAULT nextval(('tg_jednostkialt_s'::text)::regclass) NOT NULL,
    ttw_idtowaru integer,
    tjn_idjednostkialt integer,
    ja_licznik numeric DEFAULT 0,
    ja_mianownik numeric DEFAULT 0,
    ja_ean text,
    ja_waga numeric,
    ja_objetosc numeric,
    ja_flaga integer
);
