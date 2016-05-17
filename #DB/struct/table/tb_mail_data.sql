CREATE TABLE tb_mail_data (
    mail_id integer NOT NULL,
    mail_mac_id integer,
    mail_mid text,
    mail_inreplyto_mid text,
    mail_date timestamp with time zone,
    mail_subject text,
    mail_source text NOT NULL,
    mail_flag integer DEFAULT 0 NOT NULL,
    mail_address_from text,
    mail_address_to text
);
