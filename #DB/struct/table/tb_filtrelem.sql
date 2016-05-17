CREATE TABLE tb_filtrelem (
    fe_idelemu integer DEFAULT nextval('tb_filtrelem_s'::regclass) NOT NULL,
    fh_idfiltru integer,
    mv_idvalue integer,
    fe_type integer DEFAULT 0,
    fe_operation integer DEFAULT 0,
    fe_nazwa text,
    fe_defvalue text,
    fe_flaga integer DEFAULT 0
);
