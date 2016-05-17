CREATE TABLE tg_grupywww (
    tgw_idgrupy integer DEFAULT nextval('tg_grupywww_s'::regclass) NOT NULL,
    tgw_nazwa text,
    tgw_parent integer,
    tgw_l integer,
    tgw_r integer,
    tgw_sciezka text,
    tgw_flaga integer DEFAULT 1
);
