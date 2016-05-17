CREATE TABLE tg_partie (
    prt_idpartii integer DEFAULT nextval('tg_partie_s'::regclass) NOT NULL,
    ttw_idtowaru integer NOT NULL,
    prt_hashcode uuid,
    k_idklienta integer,
    zl_idzlecenia integer,
    prt_serialno text,
    prt_datawazn date,
    prt_wplyw smallint DEFAULT 1,
    prt_hashopis text,
    prt_hasanystan boolean DEFAULT false,
    prt_jm1 integer,
    prt_jm2 integer,
    prt_przelicznik1 mpq,
    prt_przelicznik2 mpq,
    prt_dokl12 smallint,
    prt_idref integer,
    prt_flaga integer DEFAULT 0,
    prt_terozroznik integer,
    prt_inkj smallint,
    zprt_id integer,
    prt_rtowaru integer NOT NULL,
    rmp_idsposobu integer,
    prt_idparent_rozm integer,
    prt_tmnotzerocount integer DEFAULT 0 NOT NULL,
    CONSTRAINT checkkj CHECK (((prt_inkj IS NULL) OR ((prt_wplyw > 0) AND (prt_inkj = ANY (ARRAY[1, 2]))) OR ((prt_wplyw < 0) AND (prt_inkj = ANY (ARRAY[1, 2, 3]))))),
    CONSTRAINT nullminuscheck CHECK (((prt_wplyw <> '-2'::integer) OR ((prt_hashcode IS NULL) AND (k_idklienta IS NULL) AND (zl_idzlecenia IS NULL) AND (prt_serialno IS NULL) AND (prt_datawazn IS NULL) AND (prt_idref IS NULL) AND (prt_terozroznik IS NULL) AND (prt_inkj IS NULL) AND (rmp_idsposobu IS NULL) AND (prt_idparent_rozm IS NULL)))),
    CONSTRAINT nullminuscheck2 CHECK (((prt_wplyw <> '-1'::integer) OR (NOT ((prt_hashcode IS NULL) AND (k_idklienta IS NULL) AND (zl_idzlecenia IS NULL) AND (prt_serialno IS NULL) AND (prt_datawazn IS NULL) AND (prt_idref IS NULL) AND (prt_terozroznik IS NULL) AND (prt_inkj IS NULL) AND (rmp_idsposobu IS NULL) AND (prt_idparent_rozm IS NULL))))),
    CONSTRAINT rozmiarowkacheck CHECK (((prt_rtowaru <> 128) OR ((rmp_idsposobu IS NOT NULL) AND (prt_idparent_rozm IS NULL)) OR ((rmp_idsposobu IS NULL) AND (prt_idparent_rozm IS NULL)))),
    CONSTRAINT rozmiarowkaelemcheck CHECK (((rmp_idsposobu IS NULL) OR ((prt_wplyw > 0) AND ((prt_idparent_rozm IS NOT NULL) OR (prt_rtowaru = 128))) OR ((prt_wplyw < 0) AND (prt_idparent_rozm IS NULL))))
);


SET search_path = gm, pg_catalog;
