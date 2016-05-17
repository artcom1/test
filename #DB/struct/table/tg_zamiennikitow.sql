CREATE TABLE tg_zamiennikitow (
    zt_idzamiennika integer DEFAULT nextval(('tg_zamiennikitow_s'::text)::regclass) NOT NULL,
    zt_idtowarusrc integer,
    zt_idtowarudesc integer,
    zt_przelicznik numeric,
    zt_flaga integer
);
