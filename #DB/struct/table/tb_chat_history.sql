CREATE TABLE tb_chat_history (
    chh_id integer NOT NULL,
    chh_chc_id integer NOT NULL,
    chh_p_idpracownika integer NOT NULL,
    chh_datetime timestamp with time zone DEFAULT now() NOT NULL,
    chh_message text NOT NULL
);
