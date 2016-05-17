CREATE TABLE tb_zdarzenia_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    zd_idzdarzenia integer NOT NULL
);
