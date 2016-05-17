CREATE TABLE tb_plugins (
    plu_id integer NOT NULL,
    plu_title text NOT NULL,
    plu_company text NOT NULL,
    plu_copyright text NOT NULL,
    plu_asm_id integer NOT NULL,
    plu_class text NOT NULL,
    plu_flag integer DEFAULT 0 NOT NULL
);
