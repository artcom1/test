CREATE TABLE tr_ruchy (
    kwc_idruchu integer DEFAULT nextval(('tr_ruchy_s'::text)::regclass) NOT NULL,
    kwc_flaga integer DEFAULT 0,
    knr_idelemusrc integer,
    knr_idelemudst integer,
    tel_idelemsrc integer,
    tel_idelemdst integer,
    kwe_idelemusrc integer,
    kwe_idelemudst integer,
    kwc_ilosc numeric DEFAULT 0,
    p_idpracownika integer,
    knw_idelemusrc integer,
    kwc_znacznik text,
    knr_idelemu_idx integer,
    dmag_iddyspozycji integer
);
