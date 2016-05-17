CREATE TABLE tb_rguival (
    rguiv_id integer DEFAULT nextval('tb_raportgui_s'::regclass) NOT NULL,
    rgui_id integer,
    rguiv_key text,
    rguiv_value text
);
