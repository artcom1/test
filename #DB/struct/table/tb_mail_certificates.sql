CREATE TABLE tb_mail_certificates (
    mct_id integer DEFAULT nextval('tb_mail_certificates_s'::regclass) NOT NULL,
    mct_subject text NOT NULL,
    mct_hash text NOT NULL
);
