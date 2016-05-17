CREATE TABLE tg_partie_narzedzia (
    pnr_idpartiinarzedzi integer DEFAULT nextval('tg_partie_narzedzia_s'::regclass) NOT NULL,
    prt_idpartii integer,
    pnr_zywotnosc numeric DEFAULT 0,
    pnr_przebieg_h numeric DEFAULT 0,
    pnr_przebieg_oper numeric DEFAULT 0,
    pnr_zuzycie numeric DEFAULT 0,
    pnr_flaga integer DEFAULT 0
);
