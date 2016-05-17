CREATE TABLE tg_kursdok (
    kd_idkursu integer DEFAULT nextval('tg_kursdok_s'::regclass) NOT NULL,
    tr_idtrans integer NOT NULL,
    wl_idwaluty integer NOT NULL,
    kd_kurs mpq DEFAULT '1'::mpq NOT NULL
);
