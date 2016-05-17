CREATE TABLE st_planst (
    pl_idplanu integer DEFAULT nextval(('st_planst_s'::text)::regclass) NOT NULL,
    str_id integer,
    nm_miesiac integer NOT NULL,
    am_id integer,
    pl_data date NOT NULL,
    p_idpracownika integer,
    pl_wartosc numeric,
    pl_wartoscbiez numeric,
    pl_wartosckoszt numeric,
    pl_wartoscbiezkoszt numeric
);
