CREATE TABLE tb_flowchart (
    fct_id integer DEFAULT nextval('tb_flowchart_s'::regclass) NOT NULL,
    fct_ownertype integer NOT NULL,
    fct_ownerid integer NOT NULL
);
