CREATE TABLE tg_skladnikizestawu (
    sz_idskladnika integer DEFAULT nextval(('tg_skladnikizestawu_s'::text)::regclass) NOT NULL,
    ttw_idtowarusrc integer,
    ttw_idtowaru integer,
    sz_ilosc numeric,
    sz_flaga integer DEFAULT 0,
    sz_lp integer
);
