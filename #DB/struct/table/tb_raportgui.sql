CREATE TABLE tb_raportgui (
    rgui_id integer DEFAULT nextval('tb_raportgui_s'::regclass) NOT NULL,
    p_idpracownikafor integer,
    rgui_dlghash text,
    rgui_opis text,
    fm_idcentrali integer
);
