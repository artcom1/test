CREATE TABLE tb_chat_members (
    chm_id integer NOT NULL,
    chm_chc_id integer NOT NULL,
    chm_p_idpracownika integer NOT NULL,
    chm_chh_id_lastreaded integer,
    chm_readdatetime timestamp with time zone
);
