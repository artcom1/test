CREATE TABLE tm_marked (
    gmm_id integer DEFAULT nextval('tm_marked_s'::regclass) NOT NULL,
    sc_sid integer DEFAULT vendo.tv_mysessionpid() NOT NULL,
    sc_simid integer NOT NULL,
    rc_idruchu integer
);
