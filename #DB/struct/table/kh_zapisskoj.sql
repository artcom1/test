CREATE TABLE kh_zapisskoj (
    zs_idskoj integer DEFAULT nextval(('kh_zapisskoj_s'::text)::regclass) NOT NULL,
    tr_idtrans integer,
    zs_counter integer DEFAULT 0,
    am_id integer,
    pl_idplatnosc integer,
    zs_counterext integer DEFAULT 0,
    pp_idplatelem integer,
    zs_typ smallint DEFAULT 0
);
