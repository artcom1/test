CREATE TABLE kh_raporty (
    rp_idraportu integer DEFAULT nextval(('kh_raporty_s'::text)::regclass) NOT NULL,
    rp_nazwa text,
    ro_idroku integer,
    rp_flaga integer DEFAULT 0,
    rp_value0 text DEFAULT 'Wartosc 1'::text,
    rp_value1 text DEFAULT 'Wartosc 2'::text,
    rp_value2 text DEFAULT 'Wartosc 3'::text,
    rp_value3 text DEFAULT 'Wartosc 4'::text,
    rp_value4 text DEFAULT 'Wartosc 5'::text
);
