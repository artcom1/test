CREATE TABLE tb_settings_storages (
    sts_id integer NOT NULL,
    sts_component text DEFAULT ''::text NOT NULL,
    sts_context text DEFAULT ''::text NOT NULL
);
