CREATE TABLE ts_imprezy (
    ti_idimprezy integer DEFAULT nextval(('ts_imprezy_s'::text)::regclass) NOT NULL,
    ti_nazwa text DEFAULT ''::text NOT NULL,
    ti_flaga integer DEFAULT 0,
    ti_nrsufix text,
    ti_szablpath text,
    ti_kolor integer DEFAULT (power((2)::double precision, (24)::double precision) - (1)::double precision)
);
