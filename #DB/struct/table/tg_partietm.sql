CREATE TABLE tg_partietm (
    ptm_id integer DEFAULT nextval('tg_partietm_s'::regclass) NOT NULL,
    prt_idpartii integer NOT NULL,
    ttm_idtowmag integer NOT NULL,
    ttw_idtowaru integer NOT NULL,
    tmg_idmagazynu integer NOT NULL,
    ptm_stanmag numeric DEFAULT 0 NOT NULL,
    ptm_rezerwacje numeric DEFAULT 0 NOT NULL,
    ptm_rezerwacjel numeric DEFAULT 0 NOT NULL,
    ptm_wtymrezlnull numeric DEFAULT 0 NOT NULL,
    ptm_inkj boolean NOT NULL,
    ptm_stanmagpotw numeric DEFAULT 0 NOT NULL,
    ptm_rtowaru integer NOT NULL,
    ptm_idparent integer,
    ptm_dzielnikrozm numeric DEFAULT 1 NOT NULL,
    ptm_pzetscount integer DEFAULT 0 NOT NULL,
    CONSTRAINT tg_partietm_checkpzetscount CHECK ((ptm_pzetscount >= 0))
);
