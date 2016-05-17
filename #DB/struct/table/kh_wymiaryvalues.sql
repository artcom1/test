CREATE TABLE kh_wymiaryvalues (
    wmv_idvalue integer DEFAULT nextval('kh_wymiaryvalues_s'::regclass) NOT NULL,
    wmm_idsumy integer,
    wme_idelemu integer,
    wms_idwymiaru integer,
    kt_idkonta integer,
    wmv_valuewnwal numeric DEFAULT 0,
    wmv_valuemawal numeric DEFAULT 0,
    wmv_valuewn numeric DEFAULT 0,
    wmv_valuema numeric DEFAULT 0,
    wl_idwaluty integer,
    wmv_isbufor boolean DEFAULT true,
    wmv_typ smallint NOT NULL,
    wmv_opis text,
    mc_miesiac integer
);
