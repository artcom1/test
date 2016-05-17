CREATE TABLE tg_towaryakcjim (
    ta_idtowaru integer DEFAULT nextval('tg_inwdupusty_s'::regclass) NOT NULL,
    zl_idzlecenia integer NOT NULL,
    ttw_idtowaru integer,
    ta_iloscmax numeric DEFAULT 0,
    ta_ilosccurrent numeric DEFAULT 0,
    tgr_idgrupy integer,
    ta_iloscmaxperklient numeric
);
