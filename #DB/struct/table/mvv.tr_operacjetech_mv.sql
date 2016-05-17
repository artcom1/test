CREATE TABLE tr_operacjetech_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    top_idoperacji integer NOT NULL
);
