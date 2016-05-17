CREATE TABLE ts_hotelestruktura (
    hs_idstruktury integer DEFAULT nextval('ts_hotelestruktura_s'::regclass) NOT NULL,
    hs_przelicznik integer DEFAULT 1,
    hs_nazwa text
);
