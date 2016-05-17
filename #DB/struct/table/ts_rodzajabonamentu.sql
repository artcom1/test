CREATE TABLE ts_rodzajabonamentu (
    ra_idrodzaju integer DEFAULT nextval(('ts_rodzajabonamentu_s'::text)::regclass) NOT NULL,
    ra_nazwa text
);
