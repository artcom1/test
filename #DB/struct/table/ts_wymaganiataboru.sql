CREATE TABLE ts_wymaganiataboru (
    wt_idwymagania integer DEFAULT nextval('ts_wymaganiataboru_s'::regclass) NOT NULL,
    wt_nazwa text NOT NULL,
    wt_opis text
);
