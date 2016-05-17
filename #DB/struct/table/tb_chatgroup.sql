CREATE TABLE tb_chatgroup (
    ctg_id integer DEFAULT nextval('tb_chatgroup_s'::regclass) NOT NULL,
    ctg_name text NOT NULL,
    ctg_flag integer DEFAULT 0 NOT NULL
);
