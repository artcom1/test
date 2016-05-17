CREATE TABLE kh_zledlugidet (
    kzld_id integer DEFAULT nextval('kh_zledlugidet_s'::regclass) NOT NULL,
    kzl_id integer NOT NULL,
    kzld_wartosc numeric DEFAULT 0 NOT NULL,
    kzld_miesiac integer NOT NULL
);
