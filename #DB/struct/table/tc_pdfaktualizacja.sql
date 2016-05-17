CREATE TABLE tc_pdfaktualizacja (
    sza_idaktualizacji integer DEFAULT nextval('tc_pdfaktualizacja_s'::regclass) NOT NULL,
    sza_typszablonu integer NOT NULL,
    sza_datatyp integer NOT NULL,
    sza_subdatatyp integer NOT NULL,
    sza_hash uuid,
    sza_nazwa text,
    sza_kod text,
    sza_zawartosc text
);
