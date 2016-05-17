CREATE TABLE tg_losyanaliza (
    lan_idanalizy integer DEFAULT nextval('tg_losyanaliza_s'::regclass) NOT NULL,
    lr_idloterii integer NOT NULL,
    tel_idelem integer NOT NULL,
    k_idklienta integer NOT NULL,
    ltw_idtowaru integer NOT NULL,
    lan_punktow numeric NOT NULL,
    lan_pktused numeric DEFAULT 0 NOT NULL,
    lan_payed boolean NOT NULL,
    lan_lastchecked timestamp without time zone DEFAULT now()
);
