CREATE TABLE tg_packelem (
    pe_idelemu integer DEFAULT nextval('tg_packelem_s'::regclass) NOT NULL,
    pk_idpaczki integer NOT NULL,
    pe_lp integer NOT NULL,
    ttw_idtowaru integer NOT NULL,
    pe_iloscf numeric DEFAULT 0 NOT NULL,
    pe_flaga integer DEFAULT 0 NOT NULL,
    tel_idelem_pzam integer,
    pe_iloscinpz numeric DEFAULT 0,
    tel_idelem_fv integer,
    tel_idelem_zam integer
);
