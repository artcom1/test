CREATE TABLE tg_waluty (
    wl_idwaluty integer DEFAULT nextval('tg_waluty_wl_rodzaj_s'::regclass) NOT NULL,
    wl_nazwa text,
    wl_skrot text NOT NULL,
    wl_podstawadefault smallint DEFAULT 1,
    CONSTRAINT tg_waluty_checkpodstawa CHECK ((wl_podstawadefault > 0))
);
