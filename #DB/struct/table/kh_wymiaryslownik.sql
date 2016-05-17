CREATE TABLE kh_wymiaryslownik (
    wms_idwymiaru integer DEFAULT nextval('kh_wymiary_s'::regclass) NOT NULL,
    wms_nazwa text,
    wms_datatype integer,
    wms_isactive boolean DEFAULT true,
    fm_idcentrali integer NOT NULL,
    wms_optional boolean DEFAULT false
);
