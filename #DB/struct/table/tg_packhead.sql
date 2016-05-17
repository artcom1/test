CREATE TABLE tg_packhead (
    pk_idpaczki integer DEFAULT nextval('tg_packhead_s'::regclass) NOT NULL,
    pk_date date DEFAULT now(),
    k_idklienta integer,
    pk_nrobcy text,
    pk_flaga integer DEFAULT 0,
    pk_numer integer,
    pk_seria character varying(4),
    pk_rok character varying(2),
    st_idstatusu integer,
    tr_idtrans_fv integer,
    pk_idref integer,
    pk_idukladu integer,
    pk_pobranie_pln numeric DEFAULT 0.00,
    fm_idcentrali integer
);
