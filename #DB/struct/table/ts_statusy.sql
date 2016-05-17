CREATE TABLE ts_statusy (
    st_idstatusu integer DEFAULT nextval(('ts_statusy_s'::text)::regclass) NOT NULL,
    st_type integer,
    st_rodzaj integer,
    st_flaga integer,
    st_lp integer,
    st_nazwa text,
    st_znaczenie integer DEFAULT 0,
    st_powiadomienie text,
    st_stz_zachowanie integer
);
