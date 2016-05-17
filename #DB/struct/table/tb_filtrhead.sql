CREATE TABLE tb_filtrhead (
    fh_idfiltru integer DEFAULT nextval('tb_filtrhead_s'::regclass) NOT NULL,
    dt_idtype integer NOT NULL,
    fh_nazwa text,
    fh_flaga integer DEFAULT 0
);
