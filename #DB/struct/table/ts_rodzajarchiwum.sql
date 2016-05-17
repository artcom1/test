CREATE TABLE ts_rodzajarchiwum (
    r_idrodzaju integer DEFAULT nextval(('ts_rodzajarchiwum_s'::text)::regclass) NOT NULL,
    r_nazwa text
);
