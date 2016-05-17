CREATE TABLE tb_vatzal (
    vz_id integer DEFAULT nextval('tb_vatzal_s'::regclass) NOT NULL,
    tr_idtrans integer,
    rr_idrozrachunku integer,
    rl_idrozliczenia integer,
    vz_refid integer,
    vz_netto numeric NOT NULL,
    vz_vat numeric NOT NULL,
    vz_brutto numeric NOT NULL,
    vz_nettoroz numeric DEFAULT 0 NOT NULL,
    vz_vatroz numeric DEFAULT 0 NOT NULL,
    vz_bruttoroz numeric DEFAULT 0 NOT NULL,
    vz_stawkavat numeric NOT NULL,
    vz_flagazw integer NOT NULL,
    vz_sequpd integer,
    vz_isleft boolean,
    rr_idrozrachunkuvat integer
);
