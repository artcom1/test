CREATE TABLE tg_teex (
    tex_idelem integer DEFAULT nextval('tg_teex_s'::regclass) NOT NULL,
    tel_idelem integer,
    session_id integer,
    tex_flaga integer DEFAULT 0,
    ttm_idtowmag integer NOT NULL,
    tex_iloscpkor numeric DEFAULT 0 NOT NULL,
    tex_iloscf numeric NOT NULL,
    tex_iloscfrez numeric DEFAULT 0 NOT NULL,
    tex_sprzedaz integer DEFAULT 0 NOT NULL,
    prt_idpartii integer NOT NULL,
    tex_nrseryjny text,
    tex_datawaznosci date,
    tel_idelemtmp integer,
    tex_skojarzony integer,
    tex_iloscfzreal numeric DEFAULT 0 NOT NULL
);
