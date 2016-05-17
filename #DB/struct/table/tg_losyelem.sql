CREATE TABLE tg_losyelem (
    lem_idelem integer DEFAULT nextval('tg_losyelem_s'::regclass) NOT NULL,
    los_idlosu integer NOT NULL,
    lan_idanalizy integer NOT NULL,
    lem_punktow numeric NOT NULL,
    tr_idtrans integer NOT NULL
);
