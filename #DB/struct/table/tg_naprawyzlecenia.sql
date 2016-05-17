CREATE TABLE tg_naprawyzlecenia (
    nz_idnaprawy integer DEFAULT nextval('tg_naprawyzlecenia_s'::regclass) NOT NULL,
    zl_idzlecenia integer NOT NULL,
    eo_idelementu integer,
    ttw_idtowaru integer,
    ob_idobiektu integer,
    nz_numerelementu text,
    nz_opis text,
    nz_ilosc numeric,
    nz_flaga integer,
    ero_idelementu integer,
    nz_ilosczreal numeric DEFAULT 0,
    nz_cecha1 text,
    nz_poczgwarancji date,
    nz_koniecgwarancji date
);
