CREATE TABLE tr_narzedzie_ruch (
    nrr_idruchu integer DEFAULT nextval('tr_narzedzie_ruch_s'::regclass) NOT NULL,
    kwh_idheadu integer,
    kwe_idelemu integer,
    prt_idpartii integer,
    ttw_idtowaru integer,
    knr_idelemu integer,
    tel_idelem_pobranie integer,
    tel_idelem_odlozenie integer,
    zl_idzlecenia integer,
    ob_idobiektu integer,
    p_idpracownika integer,
    tmg_idmagazynu integer,
    nrr_ilosc numeric,
    nrr_data_pobrania timestamp without time zone,
    nrr_data_odlozenia timestamp without time zone,
    nrr_flaga integer DEFAULT 0
);
