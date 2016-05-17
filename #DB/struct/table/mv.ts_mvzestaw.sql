CREATE TABLE ts_mvzestaw (
    mvz_idzestawu integer DEFAULT nextval('mvmultivalues_s'::regclass) NOT NULL,
    mvz_datatypefor integer NOT NULL,
    mvz_nazwa text
);
