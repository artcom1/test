CREATE TABLE tb_mail_processed (
    mpr_id integer NOT NULL,
    mpr_mac_id integer,
    mpr_mail_id integer,
    mpr_mid text,
    mpr_date timestamp with time zone,
    mpr_sender text,
    mpr_maid text NOT NULL,
    mpr_flag integer DEFAULT 0 NOT NULL
);
