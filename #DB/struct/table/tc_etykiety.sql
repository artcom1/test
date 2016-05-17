CREATE TABLE tc_etykiety (
    zpl_idetykiety integer DEFAULT nextval('tc_etykiety_s'::regclass) NOT NULL,
    zpl_datatype integer NOT NULL,
    zpl_nazwa text,
    zpl_flaga integer,
    _zpl_znaczenie integer DEFAULT 0,
    zpl_kod text,
    zpl_subdatatype integer,
    zpl_newhash uuid
);
