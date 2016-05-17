CREATE TABLE tr_technogrupy_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    thg_idgrupy integer NOT NULL
);
