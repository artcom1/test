CREATE TABLE ts_regiony (
    rj_idregionu integer DEFAULT nextval(('ts_regiony_s'::text)::regclass) NOT NULL,
    rj_nazwa text
);
