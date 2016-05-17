CREATE TABLE tg_paczkiprzewozowe (
    pp_idpaczki integer DEFAULT nextval('tg_paczkiprzewozowe_s'::regclass) NOT NULL,
    lt_idtransportu integer NOT NULL,
    pp_ilosc integer DEFAULT 1,
    pp_typ integer DEFAULT 0,
    pp_waga numeric DEFAULT 0,
    pp_dlugosc numeric DEFAULT 0,
    pp_szerokosc numeric DEFAULT 0,
    pp_wysokosc numeric DEFAULT 0,
    pp_nrobcy text,
    pp_wartosc numeric DEFAULT 0,
    pp_flaga integer DEFAULT 0,
    pp_ubezpieczenie numeric DEFAULT 0
);
