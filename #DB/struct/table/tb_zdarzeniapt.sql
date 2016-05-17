CREATE TABLE tb_zdarzeniapt (
    zdp_id integer DEFAULT nextval('tb_zdarzeniapt_s'::regclass) NOT NULL,
    zdp_name text NOT NULL,
    zdp_flag integer DEFAULT 0 NOT NULL,
    zdp_termin integer DEFAULT 0,
    zdp_shortcut text
);
