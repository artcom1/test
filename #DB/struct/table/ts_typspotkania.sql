CREATE TABLE ts_typspotkania (
    tp_idtypspotkania integer DEFAULT nextval(('ts_typspotkania_s'::text)::regclass) NOT NULL,
    tp_opis text NOT NULL
);
