CREATE TABLE tb_mail_data_addresses (
    mal_id integer NOT NULL,
    mal_mail_id integer NOT NULL,
    mal_address text NOT NULL,
    mal_displayname text,
    mal_flag integer DEFAULT 0 NOT NULL
);
