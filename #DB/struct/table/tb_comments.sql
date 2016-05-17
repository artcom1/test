CREATE TABLE tb_comments (
    com_id integer DEFAULT nextval('tb_comments_s'::regclass) NOT NULL,
    com_datatype smallint NOT NULL,
    com_subdatatype smallint,
    com_context smallint DEFAULT 0,
    com_title text,
    com_value text NOT NULL,
    com_lp integer DEFAULT 0 NOT NULL
);
