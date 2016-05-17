CREATE TABLE ts_stanowisko (
    st_idstanowiska integer DEFAULT nextval(('ts_stanowisko_s'::text)::regclass) NOT NULL,
    st_nazwa text NOT NULL,
    st_opis text NOT NULL,
    st_grwbazie text NOT NULL
);
