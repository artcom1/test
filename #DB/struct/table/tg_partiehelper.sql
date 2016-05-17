CREATE TABLE tg_partiehelper (
    prh_idpartii integer DEFAULT nextval('tg_partie_s'::regclass) NOT NULL,
    ttw_idtowaru integer NOT NULL,
    prt_idpartii integer NOT NULL,
    prh_serialno text,
    prh_datawazn date,
    prh_iloscf numeric,
    prh_askforilosc boolean DEFAULT true,
    prh_checkuniqueserialno smallint
);
