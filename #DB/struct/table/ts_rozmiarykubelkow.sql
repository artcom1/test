CREATE TABLE ts_rozmiarykubelkow (
    rk_idrozmiaru integer DEFAULT nextval('ts_rozmiarykubelkow_s'::regclass) NOT NULL,
    rk_nazwa text NOT NULL,
    rk_typrozmiaru integer NOT NULL,
    rk_rozmiar integer NOT NULL
);
