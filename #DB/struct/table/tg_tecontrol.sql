CREATE TABLE tg_tecontrol (
    tec_id integer DEFAULT nextval('tg_tecontrol_s'::regclass) NOT NULL,
    tel_idelem integer NOT NULL,
    tec_pz_ilosczreal numeric DEFAULT 0 NOT NULL,
    tec_pz_ilosczrealclosed numeric DEFAULT 0 NOT NULL,
    tec_pz_ilosc numeric DEFAULT 0 NOT NULL
);
