CREATE TABLE kh_wzorce (
    wz_idwzorca integer DEFAULT nextval(('kh_wzorce_s'::text)::regclass) NOT NULL,
    wz_nazwa text,
    wz_flaga integer DEFAULT 0,
    fm_idcentrali integer,
    ro_idroku integer,
    wz_typlaczenia integer DEFAULT (1 << 0),
    wz_def_datawpr integer DEFAULT 5,
    wz_def_dataopgosp integer DEFAULT 5,
    wz_def_datadok integer DEFAULT 6,
    wz_def_nrdowodu integer DEFAULT 4,
    wz_def_opis integer DEFAULT 3,
    wz_miesiac integer,
    wz_typrokukh smallint DEFAULT (1 << 0),
    wz_kod text
);
