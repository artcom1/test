CREATE TABLE tg_prace (
    pr_idpracy integer DEFAULT nextval(('tg_prace_s'::text)::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    pr_datapracy date DEFAULT now() NOT NULL,
    pr_opispracy text,
    zl_idzlecenia integer,
    pr_flaga integer,
    ob_idobiektu integer,
    ttw_idtowaru integer,
    pr_rbh numeric,
    pr_ilosc numeric,
    pr_koszt numeric DEFAULT 0.00,
    pr_cenajedn numeric DEFAULT 0.00,
    k_idklienta integer,
    pz_idplanu integer,
    tgc_idgrupy integer
);
