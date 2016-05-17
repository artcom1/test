CREATE TABLE tg_jednostki_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    tjn_idjedn integer NOT NULL,
    tjn_value6 text,
    tjn_value6_flag integer
);
