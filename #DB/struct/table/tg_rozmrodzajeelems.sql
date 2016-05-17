CREATE TABLE tg_rozmrodzajeelems (
    rme_idelemu integer DEFAULT nextval('tg_rozmrodzaje_s'::regclass) NOT NULL,
    rmr_idrodzaju integer NOT NULL,
    rme_kod text NOT NULL,
    rme_isactive boolean DEFAULT true NOT NULL,
    rme_idindextab integer DEFAULT nextval('tg_rozmrodzajeelems_idindextab_s'::regclass) NOT NULL,
    rme_lp integer
);
