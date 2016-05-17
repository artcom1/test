CREATE TABLE ts_wagiklienta (
    wk_idwagi integer DEFAULT nextval(('ts_wagiklienta_s'::text)::regclass) NOT NULL,
    wk_opis text NOT NULL,
    wk_liczba smallint NOT NULL
);
