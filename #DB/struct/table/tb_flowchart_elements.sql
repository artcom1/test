CREATE TABLE tb_flowchart_elements (
    fce_id integer DEFAULT nextval('tb_flowchart_elements_s'::regclass) NOT NULL,
    fct_id integer NOT NULL,
    fce_element_id text NOT NULL,
    fce_type integer NOT NULL,
    fce_value text,
    fce_rectangle text
);
