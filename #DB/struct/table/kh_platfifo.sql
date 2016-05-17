CREATE TABLE kh_platfifo (
    po_idfifo integer DEFAULT nextval('kh_platfifo_s'::regclass) NOT NULL,
    pl_idplatnosc integer,
    bk_idbanku integer,
    wl_idwaluty integer,
    po_wplyw integer NOT NULL,
    po_kwotawal numeric NOT NULL,
    po_pozostalowal numeric NOT NULL,
    po_kwotapln numeric NOT NULL,
    po_pozostalopln numeric NOT NULL,
    po_datakursu date,
    po_dataop timestamp without time zone DEFAULT now(),
    po_ref integer,
    po_flaga integer DEFAULT 0,
    rr_idrozrachunku integer,
    rl_idrozliczenia integer,
    po_refrr integer
);
