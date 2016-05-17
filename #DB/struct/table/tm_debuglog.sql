CREATE TABLE tm_debuglog (
    dl_id integer DEFAULT nextval('tm_debuglog_s'::regclass) NOT NULL,
    dl_txt text,
    dl_date timestamp without time zone DEFAULT now(),
    dl_vid integer
);
