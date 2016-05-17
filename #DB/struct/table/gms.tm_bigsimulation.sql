CREATE TABLE tm_bigsimulation (
    bsim_id integer DEFAULT nextval('tm_simcoll_s'::regclass) NOT NULL,
    bsim_sid integer DEFAULT vendo.tv_mysessionpid() NOT NULL,
    bsim_simid integer NOT NULL,
    ttw_idtowaru integer NOT NULL,
    prt_idpartiipz integer NOT NULL,
    bsim_iloscf numeric NOT NULL,
    bsim_isget boolean DEFAULT false,
    bsim_isput boolean DEFAULT false,
    tr_idtranssrc integer,
    mm_idmiejscasrc integer,
    mm_srciszero boolean DEFAULT false NOT NULL,
    mm_idmiejscadst integer,
    mm_dstiszero boolean DEFAULT false NOT NULL,
    bsim_description text,
    bsim_orderid integer
);
