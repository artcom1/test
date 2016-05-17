CREATE TABLE tb_rguilists (
    rguil_id integer DEFAULT nextval('tb_raportgui_s'::regclass) NOT NULL,
    rgui_id integer,
    rguil_listhash text,
    rguil_listxml text,
    rguil_listxmlhash text
);
