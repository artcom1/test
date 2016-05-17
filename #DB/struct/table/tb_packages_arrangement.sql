CREATE TABLE tb_packages_arrangement (
    paa_id integer NOT NULL,
    paa_lt_id integer NOT NULL,
    paa_pac_id integer NOT NULL,
    paa_ps_id integer NOT NULL,
    paa_ordinal integer NOT NULL,
    paa_x integer NOT NULL,
    paa_y integer NOT NULL,
    paa_z integer NOT NULL,
    paa_flag integer DEFAULT 0 NOT NULL
);
