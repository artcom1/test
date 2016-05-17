CREATE TABLE kh_platelem (
    pp_idplatelem integer DEFAULT nextval(('kh_platnosci_s'::text)::regclass) NOT NULL,
    pl_idplatnosc integer,
    pp_wartosc numeric DEFAULT 0,
    pp_flaga integer DEFAULT 0,
    tr_idtrans integer,
    pp_datawplywu date DEFAULT now(),
    pp_idklienta integer,
    pp_datarozliczenia date DEFAULT now(),
    pp_wspolczynnik integer DEFAULT 1,
    pp_idpracownika integer DEFAULT 0,
    pl_idplatnosc2 integer,
    pp_rozliczono numeric DEFAULT 0,
    hs_idelementu integer,
    pp_wartoscdok numeric
);
