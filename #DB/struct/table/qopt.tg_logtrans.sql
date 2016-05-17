CREATE TABLE tg_logtrans (
    lt_tid integer DEFAULT nextval('tg_logs_s'::regclass) NOT NULL,
    lt_sessid integer NOT NULL,
    lt_start timestamp without time zone NOT NULL,
    lt_end timestamp without time zone,
    lt_dbname text NOT NULL,
    lt_hostname text NOT NULL,
    lt_pid integer NOT NULL,
    lt_vsessionid text,
    lt_plogin text,
    lt_waitduration numeric DEFAULT 0,
    lt_type character varying(1),
    lt_transid integer,
    lt_maxstart timestamp without time zone
);
