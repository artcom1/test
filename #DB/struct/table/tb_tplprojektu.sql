CREATE TABLE tb_tplprojektu (
    plt_id integer DEFAULT nextval('ts_statuszlecenia_s'::regclass) NOT NULL,
    plt_temat text,
    plt_flaga integer DEFAULT 0,
    plt_zd_rodzaj integer DEFAULT 1,
    plt_zd_typ integer,
    plt_k_idklienta integer,
    plt_p_idpracownika integer,
    plt_czastrwania integer,
    plt_startstoptype smallint DEFAULT (1 << 0),
    plt_startstopdate timestamp without time zone DEFAULT now(),
    plt_opoznienie integer DEFAULT 0,
    plt_zdp_id integer,
    plt_zd_spr_zdi_id integer,
    plt_szd_idszablonu integer
);
