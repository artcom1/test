CREATE TABLE tb_packages_containers (
    pac_id integer NOT NULL,
    pac_lt_id integer NOT NULL,
    pac_ordinal integer NOT NULL,
    pac_code text,
    pac_carcode text,
    pac_cardriver text,
    pac_length integer NOT NULL,
    pac_width integer NOT NULL,
    pac_height integer NOT NULL,
    pac_maxload integer NOT NULL
);
