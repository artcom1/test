CREATE TABLE tg_paczkaspedycyjna (
    ps_idpaczki integer DEFAULT nextval('tg_paczkaspedycyjna_s'::regclass) NOT NULL,
    lt_idtransportu integer NOT NULL,
    ps_lp integer NOT NULL,
    ps_numer text,
    tps_idtypu integer,
    ps_dlugosc integer NOT NULL,
    ps_szerokosc integer NOT NULL,
    ps_wysokosc integer NOT NULL,
    ps_flaga integer NOT NULL,
    ps_ilosc integer DEFAULT 1 NOT NULL,
    ps_waga numeric,
    ps_opis text
);
