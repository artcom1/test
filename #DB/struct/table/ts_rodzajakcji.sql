CREATE TABLE ts_rodzajakcji (
    ra_idrodzaju integer DEFAULT nextval(('ts_rodzajakcji_s'::text)::regclass) NOT NULL,
    ra_opis text NOT NULL
);
