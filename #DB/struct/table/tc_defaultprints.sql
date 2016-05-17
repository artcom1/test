CREATE TABLE tc_defaultprints (
    dprn_id integer DEFAULT nextval('tc_defaultpdf_s'::regclass) NOT NULL,
    k_idklienta integer NOT NULL,
    dprn_variantuid uuid NOT NULL,
    dprn_templateuid uuid NOT NULL
);
