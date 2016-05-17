CREATE TABLE tg_elementobiektu (
    eo_idelementu integer DEFAULT nextval(('tg_elementobiektu_s'::text)::regclass) NOT NULL,
    ob_idobiektu integer,
    ttw_idtowaru integer,
    eo_poczgwarancji date,
    eo_koniecgwarancji date,
    eo_opis text,
    eo_ilosc numeric,
    eo_idelementuprev integer,
    eo_idskladnikaobiekt integer,
    eo_flaga integer DEFAULT 0,
    zl_idzlecenia integer,
    eo_numerelementu text,
    ero_idelementu integer,
    rb_idrodzaju integer,
    eo_cecha1 text
);
