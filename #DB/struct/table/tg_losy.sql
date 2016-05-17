CREATE TABLE tg_losy (
    los_idlosu integer DEFAULT nextval('tg_losy_s'::regclass) NOT NULL,
    lr_idloterii integer NOT NULL,
    k_idklienta integer NOT NULL,
    los_nrkolejny integer,
    los_pointsneeded numeric NOT NULL,
    los_pointshas numeric DEFAULT 0 NOT NULL
);
