CREATE TABLE tr_powiazanieplanprzychod (
    ppp_idelem integer DEFAULT nextval('tr_powiazanieplanprzychod_s'::regclass) NOT NULL,
    pz_idplanu integer NOT NULL,
    knr_idelemu integer NOT NULL,
    ppp_iloscroz numeric,
    ppp_iloscwyk numeric DEFAULT 0,
    ppp_flaga integer DEFAULT 0
);
