CREATE TABLE ts_mvzestawelem (
    mvze_idelemu integer DEFAULT nextval('mvmultivalues_s'::regclass) NOT NULL,
    mvz_idzestawu integer NOT NULL,
    mvs_id integer NOT NULL
);


SET search_path = mvv, pg_catalog;
