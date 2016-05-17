CREATE TABLE tr_technostpracy (
    tsp_idstanowiska integer DEFAULT nextval(('tr_technostpracy_s'::text)::regclass) NOT NULL,
    ob_idobiektu integer,
    th_idtechnologii integer,
    the_idelem integer NOT NULL,
    tsp_tpz numeric DEFAULT 0,
    tsp_tpj numeric DEFAULT 0,
    tsp_wydajnosc numeric DEFAULT 0,
    tsp_iloscosob numeric DEFAULT 0,
    tsp_flaga integer DEFAULT 0,
    tsp_kosztnah numeric DEFAULT 0,
    tsp_kosztnaj numeric DEFAULT 0,
    k_idklienta integer,
    tsp_kosztkooperacji numeric DEFAULT 0,
    tsp_zaangazpracownika numeric DEFAULT 100,
    tsp_koopczasreal numeric DEFAULT 0
);
