CREATE TABLE tc_sekwencje (
    skw_id integer DEFAULT nextval('tc_sekwencje_s'::regclass) NOT NULL,
    skw_rodzaj integer NOT NULL,
    skw_klucz text NOT NULL,
    skw_wartosc integer NOT NULL
);
