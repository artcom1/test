CREATE TABLE tg_exdetails (
    lexdet_id integer DEFAULT nextval('tg_logs_s'::regclass) NOT NULL,
    lexp_id integer NOT NULL,
    lexdet_duration numeric NOT NULL,
    lexdet_recscount integer NOT NULL,
    lexdet_line text,
    lexdet_ref integer
);
