CREATE TABLE tg_ppheadelem (
    phe_idheadelemu integer DEFAULT nextval('tg_transelem_s'::regclass) NOT NULL,
    pph_idheadu integer NOT NULL,
    phe_ref integer,
    tr_idtrans integer NOT NULL,
    ttw_idtowaru integer NOT NULL,
    ttw_idtowarundx integer NOT NULL,
    phe_wplyw integer NOT NULL,
    prt_idpartiiplus integer,
    rmp_idsposobu integer,
    phe_iloscop numeric NOT NULL,
    phe_mnoznik numeric NOT NULL,
    phe_iloscopdone numeric DEFAULT 0 NOT NULL,
    prt_idpartiiplus_nosppak integer NOT NULL,
    prt_idpartiiplusnosspak_fromref integer NOT NULL,
    tel_idelemsrcskoj integer,
    phe_docclosed boolean DEFAULT false NOT NULL,
    CONSTRAINT chectnotnull_idpartiiplus CHECK (((phe_wplyw > 0) OR (prt_idpartiiplus IS NOT NULL)))
);
