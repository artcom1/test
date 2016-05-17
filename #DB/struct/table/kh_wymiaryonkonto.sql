CREATE TABLE kh_wymiaryonkonto (
    wmk_idelemu integer DEFAULT nextval('kh_wymiary_s'::regclass) NOT NULL,
    wms_idwymiaru integer,
    kt_idkonta integer,
    wmk_isinactive smallint DEFAULT 0,
    wmk_optional boolean DEFAULT false
);
