CREATE TABLE kh_zledlugi (
    kzl_id integer DEFAULT nextval('kh_zledlugi_s'::regclass) NOT NULL,
    kzl_type integer NOT NULL,
    rc_idruchuwz integer,
    kzl_wartoscjest numeric DEFAULT 0,
    tr_idtransfz integer,
    tr_idtranspz integer,
    fm_idcentrali integer NOT NULL
);
