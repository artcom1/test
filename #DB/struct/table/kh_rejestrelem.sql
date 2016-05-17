CREATE TABLE kh_rejestrelem (
    rve_idelem integer DEFAULT nextval(('kh_rejestrelem_s'::text)::regclass) NOT NULL,
    rve_stawka numeric,
    rve_netto numeric DEFAULT 0,
    rve_vat numeric DEFAULT 0,
    rve_brutto numeric DEFAULT 0,
    rve_flaga integer DEFAULT 0,
    rh_idrejestru integer
);
