CREATE TABLE tm_hasla (
    hh_idhasla integer DEFAULT nextval(('tm_hasla_s'::text)::regclass) NOT NULL,
    tm_login text,
    tm_haslo text,
    tm_centrala integer,
    tm_passchanged timestamp without time zone DEFAULT now() NOT NULL,
    tm_encmethod integer DEFAULT 0 NOT NULL
);
