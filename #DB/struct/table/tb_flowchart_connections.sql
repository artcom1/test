CREATE TABLE tb_flowchart_connections (
    fcc_id integer DEFAULT nextval('tb_flowchart_connections_s'::regclass) NOT NULL,
    fct_id integer NOT NULL,
    fce_id_from integer NOT NULL,
    fce_id_to integer NOT NULL,
    fcc_from_handle text,
    fcc_to_handle text,
    fcc_middle_points text
);
