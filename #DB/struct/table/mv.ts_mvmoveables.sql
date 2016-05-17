CREATE TABLE ts_mvmoveables (
    mva_id integer DEFAULT nextval('mvmultivalues_s'::regclass) NOT NULL,
    mvs_srcid integer NOT NULL,
    mvs_dstid integer NOT NULL,
    mva_lp integer NOT NULL,
    mva_ctxuid text
);
