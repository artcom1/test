CREATE TABLE kh_wymiarysumvalues (
    wmm_idsumy integer DEFAULT nextval('kh_wymiarysumvalues_s'::regclass) NOT NULL,
    kt_idkonta integer,
    zp_idelzapisu integer,
    wms_idwymiaru integer,
    wmm_valuewnwal numeric DEFAULT 0,
    wmm_valuemawal numeric DEFAULT 0,
    wmm_valuerestwnwal numeric DEFAULT 0,
    wmm_valuerestmawal numeric DEFAULT 0,
    wl_idwaluty integer,
    wmm_valuewn numeric DEFAULT 0,
    wmm_valuema numeric DEFAULT 0,
    wmm_valuerestwn numeric DEFAULT 0,
    wmm_valuerestma numeric DEFAULT 0,
    wmm_isbufor boolean DEFAULT true,
    mc_miesiac integer,
    wmm_optional boolean DEFAULT false
);
