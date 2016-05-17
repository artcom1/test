CREATE TABLE tm_idtouse (
    suu_id integer DEFAULT nextval('tm_simrez_s'::regclass) NOT NULL,
    sc_id integer DEFAULT vendo.tv_mysessionpid(),
    sc_simid integer NOT NULL,
    ttm_idtowmag integer NOT NULL,
    rc_idruchuwz integer,
    rc_idruchurezl integer,
    rc_idruchurezc integer,
    suu_smietnik boolean,
    rc_idruchuwz_touse integer
);
