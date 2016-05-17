CREATE TABLE tg_rezstack (
    rs_id integer DEFAULT nextval('tg_rezstack_s'::regclass) NOT NULL,
    rc_idruchu integer NOT NULL,
    rc_recver_new integer NOT NULL,
    rc_recver_old integer NOT NULL,
    tel_idelem_new integer,
    tel_idelem_old integer,
    prt_idpartii_new integer,
    prt_idpartii_old integer,
    rc_flaga_old integer NOT NULL,
    tex_idelem_new integer,
    tex_idelem_old integer
);
