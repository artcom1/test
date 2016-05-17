CREATE TABLE kh_wzorceelemkpir (
    wk_idelemu integer DEFAULT nextval(('kh_wzorceelemkpir_s'::text)::regclass) NOT NULL,
    wzk_idwzorca integer,
    wk_nazwa text,
    wk_konto integer,
    wk_value text,
    ttw_idtowaru integer,
    tgr_idgrupy integer,
    tpg_idpodgrupy integer,
    wk_flaga integer DEFAULT 0
);
