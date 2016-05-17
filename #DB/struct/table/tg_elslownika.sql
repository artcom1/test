CREATE TABLE tg_elslownika (
    es_idelem integer DEFAULT nextval(('tg_elslownika_s'::text)::regclass) NOT NULL,
    sl_idslownika integer,
    es_text text,
    es_value text,
    ttw_idtowaru integer
);
