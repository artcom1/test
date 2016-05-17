CREATE TABLE ts_multivalues (
    mv_idvalue integer DEFAULT nextval(('ts_multivalues_s'::text)::regclass) NOT NULL,
    mv_type integer NOT NULL,
    mv_znaczenie integer,
    mv_opis text,
    mv_inputtype integer DEFAULT 0,
    mv_flaga integer DEFAULT 0,
    mv_addid integer,
    mv_nzmiennej text,
    mv_podrodzaj integer,
    mv_lp integer DEFAULT 0 NOT NULL,
    mv_zachowanie integer DEFAULT 0 NOT NULL,
    mv_formatowaniedo integer DEFAULT 2
);
