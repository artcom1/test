CREATE TABLE ts_osrodkipk (
    opk_idosrodka integer DEFAULT nextval(('ts_osrodkipk_s'::text)::regclass) NOT NULL,
    opk_kod text NOT NULL,
    opk_nazwa text NOT NULL,
    opk_kontokh text,
    opk_flaga integer DEFAULT 0,
    opk_kontokh2 text,
    opk_parent integer,
    opk_l integer,
    opk_r integer,
    opk_sciezka text
);
