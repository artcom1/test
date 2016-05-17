CREATE TABLE tg_logs (
    lg_id integer DEFAULT nextval('tg_logs_s'::regclass) NOT NULL,
    lg_sessid integer NOT NULL,
    lt_tid integer,
    lg_query text,
    lg_start timestamp without time zone NOT NULL,
    lg_end timestamp without time zone,
    lg_duration numeric,
    lg_waitduration numeric DEFAULT 0
);
