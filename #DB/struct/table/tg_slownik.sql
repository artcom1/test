CREATE TABLE tg_slownik (
    sl_idslownika integer DEFAULT nextval(('tg_slownik_s'::text)::regclass) NOT NULL,
    sl_nazwa text
);
