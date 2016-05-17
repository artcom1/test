CREATE TABLE tp_kkwhead (
    kwh_idheadu integer DEFAULT nextval(('tp_kkwhead_s'::text)::regclass) NOT NULL,
    kwh_stan numeric DEFAULT 0,
    kwh_brakow numeric DEFAULT 0,
    kwh_flaga integer DEFAULT 0,
    zl_idzlecenia integer,
    kwh_datarozp date DEFAULT now(),
    kwh_nrpojemnika text,
    kwh_nrbeczki text,
    kwh_nrkolejny integer DEFAULT 0,
    kwh_sufixnumeru text,
    kwh_numer text,
    pp_idpolproduktu integer NOT NULL,
    p_utworzyl integer,
    kwp_idplanu integer,
    kwh_iloscwmag numeric DEFAULT 0,
    kwh_ilosczr numeric DEFAULT 0
);
