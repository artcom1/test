CREATE TABLE tg_swiadruchy (
    sr_idruchu integer DEFAULT nextval('tg_swiadruchy_s'::regclass) NOT NULL,
    tel_idelem integer,
    sw_idswiadectwa integer,
    sr_ilosc numeric
);
