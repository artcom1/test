CREATE TABLE tg_explains (
    lexp_id integer DEFAULT nextval('tg_logs_s'::regclass) NOT NULL,
    lg_id integer NOT NULL,
    lexp_duration numeric NOT NULL,
    lexp_recscount integer NOT NULL,
    lexp_context text
);
