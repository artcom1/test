CREATE TABLE tm_simcoll (
    sc_id integer DEFAULT nextval('tm_simcoll_s'::regclass) NOT NULL,
    sc_sid integer DEFAULT vendo.tv_mysessionpid() NOT NULL,
    sc_simid integer NOT NULL,
    rc_idruchupz integer NOT NULL,
    sc_idtowmag integer NOT NULL,
    sc_iloscpoz numeric NOT NULL,
    sc_idmiejsca integer,
    sc_idpartiipz integer NOT NULL,
    sc_partiapzisnull boolean NOT NULL,
    sc_ilosc tm_ilosci[] DEFAULT '{"(0,0,0,0)","(0,0,0,0)","(0,0,0,0)"}'::tm_ilosci[],
    sc_deltailoscpoz numeric DEFAULT 0 NOT NULL,
    sc_deltailoscrez numeric DEFAULT 0 NOT NULL,
    sc_deltailoscwz numeric DEFAULT 0 NOT NULL,
    sc_iloscpriorited numeric DEFAULT 0,
    sc_iloscused numeric DEFAULT 0
);
