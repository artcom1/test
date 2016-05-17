CREATE TABLE tg_praceall (
    pra_idpracy integer DEFAULT nextval('tg_praceall_s'::regclass) NOT NULL,
    p_idpracownika integer,
    ttw_idtowaru integer,
    zl_idzlecenia integer,
    pra_idref integer,
    pra_typeref integer,
    pra_flaga integer,
    pra_datastart timestamp with time zone,
    pra_datastop timestamp with time zone,
    pra_rbh numeric,
    pra_ilosc numeric,
    pra_koszt numeric,
    pra_opis text,
    pra_temat text,
    pra_cenajedn numeric,
    fm_idcentrali integer,
    pra_dataaktkosztu timestamp with time zone,
    pra_zaangazpracownika numeric DEFAULT 100,
    pra_cenajednnetto numeric,
    pra_kosztnetto numeric,
    pra_narzutprocent numeric DEFAULT 0
);