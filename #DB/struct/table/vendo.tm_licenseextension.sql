CREATE TABLE tm_licenseextension (
    nsl_id integer DEFAULT nextval('tm_numeryseryjne_s'::regclass) NOT NULL,
    ns_idnumeru integer NOT NULL,
    nsl_updatedata timestamp without time zone DEFAULT now(),
    p_idpracownika integer,
    ns_idnumeru_prev integer NOT NULL
);
