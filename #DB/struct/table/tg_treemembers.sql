CREATE TABLE tg_treemembers (
    tt_idelemu integer DEFAULT nextval('tg_treemembers_s'::regclass) NOT NULL,
    te_idelemu_f integer NOT NULL,
    te_idelemu_s integer NOT NULL,
    ttw_idtowaru integer
);
