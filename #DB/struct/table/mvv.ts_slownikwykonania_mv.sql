CREATE TABLE ts_slownikwykonania_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tsw_idslownika integer NOT NULL
);
