CREATE TABLE ts_charakter_towaru_raben (
    ctr_idcharak integer DEFAULT nextval('ts_charakter_towaru_raben_s'::regclass) NOT NULL,
    ctr_kod text NOT NULL,
    ctr_opis text NOT NULL
);
