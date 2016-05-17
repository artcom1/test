CREATE TABLE tm_allowed (
    nal_id integer DEFAULT nextval('tm_allowed_s'::regclass) NOT NULL,
    nal_sid integer DEFAULT vendo.tv_mysessionpid() NOT NULL,
    nal_simid integer NOT NULL,
    tel_idelem integer,
    tex_idelem integer
);
