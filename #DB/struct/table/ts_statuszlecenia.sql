CREATE TABLE ts_statuszlecenia (
    szl_idstatusu integer DEFAULT nextval(('ts_statuszlecenia_s'::text)::regclass) NOT NULL,
    szl_lp integer DEFAULT 0,
    szl_opis text,
    szl_flaga integer DEFAULT 0,
    szl_opoznienie integer,
    szl_rodzajzlecenia integer,
    szl_zd_rodzaj integer DEFAULT 0,
    szl_zd_typ integer DEFAULT 0,
    szl_zd_ktoryklient integer DEFAULT 0,
    szl_zd_idklienta integer DEFAULT 0,
    szl_zd_ktorypracownik integer DEFAULT 0,
    szl_zd_datarozp integer DEFAULT 0,
    szl_zd_datazak integer DEFAULT 0,
    szl_opoznienie2 integer DEFAULT 0,
    szl_zd_temat text,
    szl_zd_idpracownika integer DEFAULT 0,
    zpl_idetykiety integer,
    szl_skrypt text,
    szl_zd_ownertype integer DEFAULT 0,
    szl_zd_iddzialu integer,
    szl_zd_idroli integer,
    szl_zd_termin integer DEFAULT 0,
    szl_opoznienie3 integer DEFAULT 0,
    szl_zd_opis text,
    szl_mtpl_mail_id integer,
    szl_zd_szl_idstatusu integer,
    szl_szd_idszablonu integer
);