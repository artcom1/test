CREATE TABLE tg_zmianycenzakupu (
    zcz_id integer DEFAULT nextval('tg_zmianycenzakupu_s'::regclass) NOT NULL,
    ttw_idtowaru integer NOT NULL,
    fm_idcentrali integer NOT NULL,
    tr_idtrans integer NOT NULL,
    zcz_typ smallint NOT NULL,
    zcz_cena numeric NOT NULL,
    zcz_waluta integer NOT NULL,
    zcz_dataop timestamp without time zone DEFAULT now() NOT NULL
);
