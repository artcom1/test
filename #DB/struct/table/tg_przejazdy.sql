CREATE TABLE tg_przejazdy (
    pr_idprzejazdu integer DEFAULT nextval(('tg_przejazdy_s'::text)::regclass) NOT NULL,
    p_idpracownika integer,
    ob_idobiektu integer,
    pr_skad text DEFAULT ''::character varying NOT NULL,
    pr_dokad text DEFAULT ''::character varying NOT NULL,
    pr_kilometry numeric DEFAULT 0 NOT NULL,
    pr_dataprzejazdu date DEFAULT now() NOT NULL,
    zl_idzlecenia integer,
    pr_cel text,
    pr_flaga integer,
    fm_idcentrali integer,
    lt_idtransportu integer DEFAULT 0,
    pr_kosztnetto numeric DEFAULT 0.00,
    pr_kosztbrutto numeric DEFAULT 0.00
);
