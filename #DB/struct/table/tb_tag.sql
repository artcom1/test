CREATE TABLE tb_tag (
    tag_id integer DEFAULT nextval('tb_tag_s'::regclass) NOT NULL,
    tag_parent integer,
    tag_left integer,
    tag_right integer,
    tag_name text NOT NULL,
    tag_flag integer NOT NULL,
    p_idpracownika integer,
    tag_datatype smallint,
    tag_datatypeid integer,
    tag_subdatatype integer
);
