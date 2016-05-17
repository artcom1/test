CREATE UNLOGGED TABLE tm_oznaczoneruchy (
    ozr_id integer DEFAULT nextval('tm_oznaczoneruchy_s'::regclass) NOT NULL,
    ozr_setid bigint NOT NULL,
    rc_idruchu integer NOT NULL
);
