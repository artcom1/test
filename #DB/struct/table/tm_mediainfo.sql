CREATE TABLE tm_mediainfo (
    mi_idmediainfo integer DEFAULT nextval('tm_mediainfo_s'::regclass) NOT NULL,
    mi_type integer NOT NULL,
    mi_idref integer NOT NULL,
    mi_ilosczdjec integer DEFAULT 0 NOT NULL,
    mi_zmianazdjec timestamp without time zone DEFAULT now() NOT NULL
);
