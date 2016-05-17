CREATE TABLE tm_mobileprofiles (
    mpf_id integer DEFAULT nextval('tm_mobileprofiles_s'::regclass) NOT NULL,
    mpf_typaplikacji integer NOT NULL,
    mpf_nazwa text NOT NULL,
    mpf_dane text NOT NULL
);
