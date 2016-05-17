CREATE TABLE tb_sheetgui (
    sgui_id integer DEFAULT nextval('tb_sheetgui_s'::regclass) NOT NULL,
    sgui_sheetuid uuid,
    sgui_baseuid uuid,
    sgui_exuid uuid,
    p_idpracownika integer,
    sgui_tytul text DEFAULT ''::text,
    sgui_lp integer,
    sgui_flaga integer DEFAULT 0
);
