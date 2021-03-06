CREATE TABLE kh_zapisyelem (
    zp_idelzapisu integer DEFAULT nextval(('kh_zapisyelem_s'::text)::regclass) NOT NULL,
    zk_idzapisu integer,
    kt_idkontawn integer,
    kt_idkontama integer,
    zp_fullnumer text,
    zp_numer integer DEFAULT 0,
    zp_kwota numeric DEFAULT 0 NOT NULL,
    wl_idwaluty integer DEFAULT 1 NOT NULL,
    wl_przelicznik mpq DEFAULT '1'::mpq NOT NULL,
    zp_opis text,
    zp_flaga integer DEFAULT 0,
    zp_nrdowodu text,
    tr_idtrans integer,
    pl_idplatnosc integer,
    am_id integer,
    mc_miesiac integer,
    r_idroku integer,
    pp_idplatelem integer,
    zp_datadok date,
    zp_kwotawal numeric NOT NULL,
    zp_typ smallint DEFAULT 1,
    zp_dataplatnosci date,
    kt_idkontawkh integer,
    zp_pozostalowkhwal numeric,
    zp_pozostalowkh numeric,
    zp_dorozpisaniaelemswkh integer
);
