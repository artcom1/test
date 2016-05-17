CREATE TABLE tg_zmianacenypz (
    cpz_idzmiany integer DEFAULT nextval(('tg_zmianacenypz_s'::text)::regclass) NOT NULL,
    tel_idelem integer,
    ttw_ostcena numeric DEFAULT 0,
    ttw_ostwaluta integer,
    cpz_datazamkniecia date DEFAULT now(),
    p_idpracownika integer,
    cpz_flaga integer DEFAULT 0
);
