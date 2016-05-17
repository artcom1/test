CREATE TABLE ts_efekt (
    ef_idefektu integer DEFAULT nextval(('ts_efekt_s'::text)::regclass) NOT NULL,
    ef_opis text NOT NULL
);
