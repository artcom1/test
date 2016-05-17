CREATE TABLE __tb_mail_processed (
    mr_id integer DEFAULT nextval('tb_mail_processed_s'::regclass) NOT NULL,
    mr_email text NOT NULL,
    mr_uid text NOT NULL
);
