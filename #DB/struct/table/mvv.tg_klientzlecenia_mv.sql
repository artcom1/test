CREATE TABLE tg_klientzlecenia_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    kz_idklienta integer NOT NULL
);
