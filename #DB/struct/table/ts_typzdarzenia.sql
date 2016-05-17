CREATE TABLE ts_typzdarzenia (
    tsz_idtypu integer DEFAULT nextval(('ts_typzdarzenia_s'::text)::regclass) NOT NULL,
    tsz_nazwatypu text NOT NULL,
    zd_rodzaj integer DEFAULT 0,
    tsz_oldid integer,
    tsz_znaczenie integer DEFAULT 0
);
