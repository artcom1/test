CREATE TABLE tr_harmonogram (
    hm_idharmonogramu integer DEFAULT nextval('tr_harmonogram_s'::regclass) NOT NULL,
    w_idwydzialu integer,
    ob_idobiektu integer,
    hm_odczasu timestamp without time zone NOT NULL,
    hm_doczasu timestamp without time zone,
    pp_idprzyczyny integer DEFAULT 0,
    hm_opis text,
    hm_typ integer DEFAULT 0,
    hm_refid integer,
    hm_reftype integer,
    knw_idelemu integer
);
