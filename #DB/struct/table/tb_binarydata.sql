CREATE TABLE tb_binarydata (
    bd_iddata integer DEFAULT nextval(('tb_binarydata_s'::text)::regclass) NOT NULL,
    bd_data text,
    bd_md5 text,
    bd_refcount integer,
    db_flag integer DEFAULT 0
);
