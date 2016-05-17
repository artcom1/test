CREATE TABLE tg_realizacjaplanuprod (
    rpp_idrealizacji integer DEFAULT nextval(('tg_realizacjaplanuprod_s'::text)::regclass) NOT NULL,
    pz_idplanu integer,
    rpp_ilosc numeric,
    rpp_flaga integer,
    tel_idelem integer,
    nz_idnaprawy integer
);
