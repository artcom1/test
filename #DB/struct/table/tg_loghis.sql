CREATE TABLE tg_loghis (
    lgh_id integer DEFAULT nextval('tg_log_s'::regclass) NOT NULL,
    lgh_idpracownika integer NOT NULL,
    lgh_startdate timestamp without time zone DEFAULT now() NOT NULL,
    lgh_enddate timestamp without time zone,
    lgh_refdatatype integer NOT NULL,
    lgh_refid integer,
    lgh_functionid uuid NOT NULL,
    lgh_extext text
);
