CREATE TABLE tg_obiekty_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    ob_idobiektu integer NOT NULL
);
