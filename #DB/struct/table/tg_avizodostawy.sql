CREATE TABLE tg_avizodostawy (
    ad_idaviza integer DEFAULT nextval('tg_packelem_s'::regclass) NOT NULL,
    tr_idtrans integer NOT NULL,
    ttw_idtowaru integer NOT NULL,
    ad_iloscf numeric DEFAULT 0 NOT NULL,
    ad_typ integer NOT NULL
);
