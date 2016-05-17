CREATE TABLE tg_grupytow (
    tgr_idgrupy integer DEFAULT nextval(('tg_grupytow_s'::text)::regclass) NOT NULL,
    tgr_nazwa text DEFAULT ''::text,
    br_idbranzy integer DEFAULT 0,
    tgr_flaga integer DEFAULT 1,
    tgr_parent integer,
    tgr_l integer,
    tgr_r integer,
    tgr_sciezka text
);
