CREATE TABLE ts_profile (
    pf_idprofilu integer DEFAULT nextval(('ts_profile_s'::text)::regclass) NOT NULL,
    pf_nazwa character varying(30) NOT NULL
);
