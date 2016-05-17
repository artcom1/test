CREATE TABLE ts_spedycje_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    sp_idspedytora integer NOT NULL
);


SET search_path = mv, pg_catalog;
