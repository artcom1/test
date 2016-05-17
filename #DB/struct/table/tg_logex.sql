CREATE TABLE tg_logex (
    lgex_id integer DEFAULT nextval('tg_log_s'::regclass) NOT NULL,
    lgex_txt text
);
