CREATE TABLE kr_salda (
    sd_idsalda integer DEFAULT nextval('kr_salda_s'::regclass) NOT NULL,
    k_idklienta integer,
    kt_idkonta integer,
    sd_nrkontatxt text,
    sd_wn numeric DEFAULT 0,
    sd_ma numeric DEFAULT 0,
    sd_wnnr numeric DEFAULT 0,
    sd_manr numeric DEFAULT 0,
    sd_wnpoz numeric DEFAULT 0,
    sd_mapoz numeric DEFAULT 0,
    ro_idroku integer,
    fm_idcentrali integer
);
