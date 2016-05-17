CREATE TABLE tp_ruchy (
    kwr_idruchu integer DEFAULT nextval(('tp_ruchy_s'::text)::regclass) NOT NULL,
    kwr_flaga integer DEFAULT 0,
    kwr_etapsrc integer,
    kwr_etapdst integer,
    tel_idelemsrc integer,
    tel_idelemdst integer,
    kwr_ilosc numeric DEFAULT 0,
    kwh_idheadudst integer,
    kwr_data date DEFAULT now()
);
