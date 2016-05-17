CREATE TABLE tg_towaryakcjimdet (
    tad_id integer DEFAULT nextval('tg_inwdupusty_s'::regclass) NOT NULL,
    ta_idtowaru integer NOT NULL,
    tam_ilosccurrent numeric DEFAULT 0 NOT NULL,
    k_idklienta integer NOT NULL
);
