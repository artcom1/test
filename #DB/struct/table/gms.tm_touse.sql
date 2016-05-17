CREATE TABLE tm_touse (
    stu_id integer DEFAULT nextval('tm_touse_s'::regclass) NOT NULL,
    sc_sid integer DEFAULT vendo.tv_mysessionpid() NOT NULL,
    sc_simid integer NOT NULL,
    ttm_idtowmag integer,
    mm_idmiejsca integer,
    prt_idpartiipz integer,
    rc_idruchupz integer,
    rc_idruchuwz integer,
    stu_iloscwz_pnull numeric DEFAULT 0 NOT NULL,
    stu_iloscwz_p numeric DEFAULT 0 NOT NULL,
    rc_idruchurez integer,
    stu_iloscrez_pnull numeric DEFAULT 0 NOT NULL,
    stu_iloscrez_p numeric DEFAULT 0 NOT NULL,
    prt_idpartiil integer,
    stu_iloscrezl_pnull numeric DEFAULT 0 NOT NULL,
    stu_iloscrezl_p numeric DEFAULT 0 NOT NULL
);
