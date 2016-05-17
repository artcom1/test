CREATE TABLE tm_childs (
    gcl_id integer DEFAULT nextval('tm_childs_s'::regclass) NOT NULL,
    gcl_sessionid integer DEFAULT vendo.initmysession() NOT NULL,
    rc_idruchu_parent integer NOT NULL,
    rc_idruchu_child integer NOT NULL
);
