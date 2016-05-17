CREATE TABLE tb_bankirel (
    br_idrelacji integer DEFAULT nextval('tb_bankirel_s'::regclass) NOT NULL,
    bk_idbanku integer,
    k_idklienta integer,
    tmg_idmagazynu integer,
    br_priorytet integer DEFAULT 0,
    br_flaga integer DEFAULT 0,
    br_nrkonta text,
    br_nrkontanorm text,
    br_opis text,
    br_iszagranica boolean DEFAULT false,
    br_swift text,
    br_kododdz text,
    br_ktoplaci smallint DEFAULT 0,
    pw_idpowiatu integer,
    wl_idwaluty integer
);
