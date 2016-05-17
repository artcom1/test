CREATE TABLE tb_pp (
    ppm_id integer DEFAULT nextval(('tb_pp_s'::text)::regclass) NOT NULL,
    ppm_opis text,
    p_idpracownikafor integer,
    ppm_type integer,
    ppm_refid integer,
    ppm_flaga integer DEFAULT 0,
    ppm_nakiedy timestamp without time zone,
    td_idtodo integer,
    tr_idtrans integer,
    zl_idzlecenia integer,
    pr_idpracy integer,
    sz_idetapu integer,
    ht_idhotelu integer,
    dz_iddzialu integer DEFAULT 0,
    ppm_znaczenie integer DEFAULT 0 NOT NULL
);
