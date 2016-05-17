CREATE TABLE ts_typpaczkispedycyjnej (
    tps_idtypu integer DEFAULT nextval('ts_typpaczkispedycyjnej_s'::regclass) NOT NULL,
    tps_nazwa text NOT NULL,
    tps_dlugosc integer NOT NULL,
    tps_szerokosc integer NOT NULL,
    tps_wysokosc integer NOT NULL,
    tps_flaga integer NOT NULL
);
