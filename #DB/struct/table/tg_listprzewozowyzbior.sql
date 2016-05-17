CREATE TABLE tg_listprzewozowyzbior (
    lpz_idzbioru integer DEFAULT nextval('tg_listprzewozowyzbior_s'::regclass) NOT NULL,
    lpz_numer text,
    sp_typ integer DEFAULT 0,
    lpz_flaga integer DEFAULT 0,
    lpz_datautworzenia timestamp without time zone DEFAULT now(),
    lpz_datawyslania timestamp without time zone,
    fm_idcentrali integer,
    lpz_opis text,
    fm_index integer
);
