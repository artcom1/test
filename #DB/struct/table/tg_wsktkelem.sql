CREATE TABLE tg_wsktkelem (
    wt_idwsk integer DEFAULT nextval('tg_wsktkelem_s'::regclass) NOT NULL,
    tk_idelem integer,
    rc_idruchu integer
);
