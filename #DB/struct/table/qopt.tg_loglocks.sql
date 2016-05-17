CREATE TABLE tg_loglocks (
    ll_id integer DEFAULT nextval('tg_logs_s'::regclass) NOT NULL,
    ll_sessid integer NOT NULL,
    lg_id integer,
    ll_start timestamp without time zone NOT NULL,
    ll_end timestamp without time zone,
    ll_transoid integer,
    ll_duration numeric,
    ll_reloid integer,
    ll_type text
);
