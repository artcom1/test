CREATE TABLE tg_towary_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    ttw_idtowaru integer NOT NULL
);
