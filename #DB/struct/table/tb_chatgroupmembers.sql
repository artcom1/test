CREATE TABLE tb_chatgroupmembers (
    ctm_id integer DEFAULT nextval('tb_chatgroupmembers_s'::regclass) NOT NULL,
    ctg_id integer NOT NULL,
    ctu_id integer NOT NULL
);
