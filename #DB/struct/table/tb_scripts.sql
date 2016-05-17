CREATE TABLE tb_scripts (
    scr_id integer NOT NULL,
    scr_name text NOT NULL,
    scr_interface text NOT NULL,
    scr_source text NOT NULL,
    scr_modtimestamp timestamp without time zone DEFAULT now()
);
