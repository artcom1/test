CREATE TABLE ts_powiaty_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    pw_idpowiatu integer NOT NULL
);
