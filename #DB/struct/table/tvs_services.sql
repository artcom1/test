CREATE TABLE tvs_services (
    sv_id integer DEFAULT nextval('tvs_services_s'::regclass) NOT NULL,
    sv_code text,
    sv_seqno integer,
    sv_dbhash text
);
