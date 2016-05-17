CREATE TABLE tg_produkcja (
    tsk_idskladnika integer DEFAULT nextval(('tg_produkcja_s'::text)::regclass) NOT NULL,
    tsk_idreceptury integer DEFAULT 0,
    tsk_flaga integer DEFAULT 0,
    ttw_idtowaru integer,
    tsk_ilosc numeric DEFAULT 0,
    tsk_waga numeric DEFAULT 1,
    tsk_nazwa text DEFAULT ''::character varying,
    tmg_idmagazynu integer,
    tsk_zanik numeric,
    tsk_wspkoszt numeric,
    tsk_wspogolny numeric,
    fm_idcentrali integer
);
