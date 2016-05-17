CREATE TABLE tb_mail_data_attachments (
    mat_id integer NOT NULL,
    mat_mail_id integer NOT NULL,
    mat_name text NOT NULL,
    mat_hash text NOT NULL,
    mat_size integer NOT NULL
);
