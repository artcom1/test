CREATE TABLE ts_grupycen (
    tgc_idgrupy integer DEFAULT nextval('ts_grupycen_s'::regclass) NOT NULL,
    tgc_nazwa text,
    tgc_flaga integer DEFAULT 0
);
