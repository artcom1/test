CREATE TABLE tg_towaryloterii (
    ltw_idtowaru integer DEFAULT nextval('tg_towaryloterii_s'::regclass) NOT NULL,
    lr_idloterii integer NOT NULL,
    ttw_idtowaru integer,
    tgr_idgrupy integer,
    ltw_mnoznikpunktow numeric DEFAULT 1 NOT NULL
);
