CREATE TABLE kh_wymiaryobroty (
    wmo_idobrotu integer DEFAULT nextval('kh_wymiaryobroty_s'::regclass) NOT NULL,
    ro_idroku integer,
    kt_idkonta integer,
    ktn_idkonta integer,
    wms_idwymiaru integer,
    wme_idelemu integer,
    mc_miesiac integer,
    wmo_sumwnbuf numeric DEFAULT 0,
    wmo_summabuf numeric DEFAULT 0,
    wmo_sumwn numeric DEFAULT 0,
    wmo_summa numeric DEFAULT 0
);
