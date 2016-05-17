CREATE TABLE tm_vusers (
    id integer,
    backend_pid integer,
    table_oid oid,
    p_idpracownika integer,
    creation_date timestamp without time zone DEFAULT now(),
    winusersid text,
    appname text
);
