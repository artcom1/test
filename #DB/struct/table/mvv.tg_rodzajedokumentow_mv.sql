CREATE TABLE tg_rodzajedokumentow_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tr_rodzaj integer NOT NULL
);
