CREATE TABLE tr_zmiany (
    zm_idzmiany integer DEFAULT nextval('tr_zmiany_s'::regclass) NOT NULL,
    zm_nazwa text,
    zm_godzinaroz time without time zone,
    zm_godzinazak time without time zone,
    zm_flaga integer DEFAULT 0,
    zm_iloscrbh numeric DEFAULT 0
);
