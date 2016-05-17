CREATE TABLE tg_kompletyzlecenia (
    kz_idkompletu integer DEFAULT nextval('tg_kompletyzlecenia_s'::regclass) NOT NULL,
    zl_idzlecenia integer NOT NULL,
    ero_idelementu integer NOT NULL,
    rb_idrodzaju integer NOT NULL,
    kz_opis text,
    kz_ilosc numeric
);
