CREATE TABLE ts_statusyzachowanie (
    stz_idzachowania integer DEFAULT nextval('ts_statusyzachowanie_s'::regclass) NOT NULL,
    st_idstatusu_old integer,
    st_idstatusu_new integer,
    st_type integer,
    st_rodzaj integer,
    stz_akcja integer DEFAULT 0,
    stz_zachowanie integer DEFAULT 0,
    stz_flaga integer DEFAULT 0,
    stz_opis text
);
