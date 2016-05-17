CREATE TABLE ts_punktywydaniaeprzesylek (
    pwep_idpunktu integer DEFAULT nextval('ts_punktywydaniaeprzesylek_s'::regclass) NOT NULL,
    pwep_pni text NOT NULL,
    pwep_y text,
    pwep_x text,
    pwep_wojewodztwo text,
    pwep_powiat text,
    pwep_gmina text,
    pwep_nazwa text,
    pwep_kod text,
    pwep_miejscowosc text,
    pwep_ulica text,
    pwep_telefon text,
    pwep_opis text,
    pwep_stan text,
    pwep_flaga integer DEFAULT 0,
    sp_typ integer DEFAULT 0 NOT NULL
);
