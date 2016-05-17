CREATE TABLE tg_log (
    lg_id integer DEFAULT nextval(('tg_log_s'::text)::regclass) NOT NULL,
    lg_ref integer,
    lg_typeref integer,
    lg_txt text,
    lg_uid integer,
    lg_aref integer,
    lg_atyperef integer,
    lg_date timestamp without time zone DEFAULT now(),
    lg_zauid integer,
    lgex_id integer
);
