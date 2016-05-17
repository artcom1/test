CREATE TABLE tb_etapprojektu (
    pt_idetapu integer DEFAULT nextval('ts_statuszlecenia_s'::regclass) NOT NULL,
    szl_idstatusu integer,
    pt_nazwa text,
    fm_idcentrali integer,
    pt_typzlecenia smallint,
    pt_flaga integer DEFAULT 0,
    pt_to integer
);
