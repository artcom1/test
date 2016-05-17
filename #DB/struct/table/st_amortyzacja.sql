CREATE TABLE st_amortyzacja (
    am_id integer DEFAULT nextval(('st_amortyzacja_s'::text)::regclass) NOT NULL,
    st_id integer,
    ro_idrok integer,
    nm_miesiac integer NOT NULL,
    am_dataobr date NOT NULL,
    am_wartam numeric,
    am_wartamkoszt numeric,
    am_czyksieg integer NOT NULL,
    pl_idplanu integer,
    fm_idcentrali integer
);
