CREATE TABLE tg_kliencilogistyki (
    kl_idklientalog integer DEFAULT nextval(('tg_kliencilogistyki_s'::text)::regclass) NOT NULL,
    k_idklienta integer,
    lt_idtransportu integer,
    kl_flaga integer,
    kl_opis text,
    kl_lp integer,
    st_idstatusu integer,
    kl_godzina time without time zone,
    kl_nazwa text DEFAULT ''::text,
    kl_ulica text DEFAULT ''::text,
    kl_nrlokalu text DEFAULT ''::text,
    kl_kodpocztowy text DEFAULT ''::text,
    kl_miejscowosc text DEFAULT ''::text,
    kl_nrdomu text DEFAULT ''::text,
    kl_telefon text DEFAULT ''::text
);
