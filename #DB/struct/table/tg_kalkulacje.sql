CREATE TABLE tg_kalkulacje (
    kk_idkalk integer DEFAULT nextval(('tg_kalkulacje_s'::text)::regclass) NOT NULL,
    ttw_idtowaru integer,
    kk_lp integer DEFAULT 0,
    kk_flaga integer DEFAULT 0,
    kk_nazwa text,
    kk_funkcja text,
    tgr_idgrupy integer,
    kk_default text DEFAULT ''::text,
    sl_idslownika integer,
    tb_idtabeli integer,
    kk_symbol text NOT NULL
);
