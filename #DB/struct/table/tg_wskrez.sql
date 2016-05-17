CREATE TABLE tg_wskrez (
    wr_idwsk integer DEFAULT nextval('tg_wskrez_s'::regclass) NOT NULL,
    tel_idelem_fv integer,
    tel_idelem_pz integer,
    wr_priorytet integer DEFAULT 99999,
    rc_idruchupz integer,
    tel_idelem_inw integer,
    wr_ilosc_inw numeric DEFAULT 0,
    wr_rezid integer
);
