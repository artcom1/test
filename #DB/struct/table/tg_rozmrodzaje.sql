CREATE TABLE tg_rozmrodzaje (
    rmr_idrodzaju integer DEFAULT nextval('tg_rozmrodzaje_s'::regclass) NOT NULL,
    rmr_kod text NOT NULL
);
