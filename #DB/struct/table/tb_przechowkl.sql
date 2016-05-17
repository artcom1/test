CREATE TABLE tb_przechowkl (
    pk_idprzechowkl integer DEFAULT nextval('tb_przechowkl_s'::regclass) NOT NULL,
    k_idklienta integer,
    sp_idprzechow integer,
    pk_okresi_dni integer,
    pk_okresi_kwota numeric,
    pk_okresii_dni integer,
    pk_okresii_kwota numeric,
    pk_okresiii_kwota numeric
);
