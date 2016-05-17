CREATE TABLE tm_vorders (
    ord_id integer DEFAULT nextval('tm_vorders_s'::regclass) NOT NULL,
    ord_backendpid integer DEFAULT pg_backend_pid() NOT NULL,
    ord_timestamp timestamp without time zone DEFAULT now(),
    ord_order text,
    ord_type smallint DEFAULT 0
);
