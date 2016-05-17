CREATE TABLE tg_hoteleelem (
    he_idelemu integer DEFAULT nextval('tg_hoteleelem_s'::regclass) NOT NULL,
    hs_idstruktury integer NOT NULL,
    ht_idhotelu integer NOT NULL,
    he_iloscpokoi integer DEFAULT 1,
    he_cenajedn numeric,
    wl_idwaluty integer
);
