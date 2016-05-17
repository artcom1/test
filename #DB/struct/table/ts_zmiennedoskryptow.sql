CREATE TABLE ts_zmiennedoskryptow (
    zds_idzmiennej integer DEFAULT nextval(('ts_zmiennedoskryptow_s'::text)::regclass) NOT NULL,
    zds_opis text,
    zds_nazwa text,
    zds_value numeric
);
