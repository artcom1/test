CREATE TABLE ts_drzewa (
    trr_iddrzewa integer DEFAULT nextval('ts_drzewa_s'::regclass) NOT NULL,
    trr_nazwa text NOT NULL
);
