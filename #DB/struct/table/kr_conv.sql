CREATE TABLE kr_conv (
    cv_id integer DEFAULT nextval('kr_conv_s'::regclass) NOT NULL,
    k_idklienta integer,
    tr_idtrans integer,
    pl_idplatnosc integer,
    hs_idelementu integer,
    cv_valuewn numeric DEFAULT 0,
    cv_valuema numeric DEFAULT 0,
    cv_valuewnpln numeric DEFAULT 0,
    cv_valuemapln numeric DEFAULT 0,
    wl_idwaluty integer,
    cv_iszaliczkowa integer DEFAULT 0,
    cv_opis text,
    tr_idtrans_zal integer
);
