CREATE TABLE tb_ftphost (
    fth_idhost integer DEFAULT nextval('tb_ftphost_s'::regclass) NOT NULL,
    fth_name text NOT NULL,
    fth_address text NOT NULL,
    fth_port integer DEFAULT 21,
    fth_filespath text DEFAULT ''::text
);
