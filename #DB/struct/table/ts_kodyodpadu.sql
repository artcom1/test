CREATE TABLE ts_kodyodpadu (
    ko_idkodu integer DEFAULT nextval('ts_kodyodpadu_s'::regclass) NOT NULL,
    ko_kod text,
    ko_nazwa text,
    ko_flaga integer[]
);
