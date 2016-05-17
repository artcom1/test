CREATE TABLE tr_technoelem_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    the_idelem integer NOT NULL
);
