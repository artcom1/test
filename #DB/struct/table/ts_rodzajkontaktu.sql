CREATE TABLE ts_rodzajkontaktu (
    rk_idrodzajkontaktu integer DEFAULT nextval(('ts_rodzajkontaktu_s'::text)::regclass) NOT NULL,
    rk_opis text NOT NULL
);
