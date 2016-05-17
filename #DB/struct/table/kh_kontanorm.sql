CREATE TABLE kh_kontanorm (
    ktn_idkonta integer DEFAULT nextval('kh_konta_s'::regclass) NOT NULL,
    fm_idcentrali integer,
    ktn_nrkonta text NOT NULL
);
