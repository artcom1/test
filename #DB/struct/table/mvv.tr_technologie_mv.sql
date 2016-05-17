CREATE TABLE tr_technologie_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    th_idtechnologii integer NOT NULL,
    th_value5 text,
    th_value5_flag integer
);
