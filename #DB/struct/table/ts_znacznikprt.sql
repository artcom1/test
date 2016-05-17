CREATE TABLE ts_znacznikprt (
    zprt_id integer DEFAULT nextval('ts_znacznikprt_s'::regclass) NOT NULL,
    zprt_code text,
    zprt_nazwa text
);
