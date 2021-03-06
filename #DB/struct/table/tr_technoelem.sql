CREATE TABLE tr_technoelem (
    the_idelem integer DEFAULT nextval(('tr_technoelem_s'::text)::regclass) NOT NULL,
    th_idtechnologii integer NOT NULL,
    top_idoperacji integer NOT NULL,
    the_nazwa text,
    the_prbrakow numeric DEFAULT 0,
    the_lp integer NOT NULL,
    the_flaga integer DEFAULT 0,
    the_nextbegin_x numeric DEFAULT 0,
    tjn_idjedn integer,
    ct_idciagu integer,
    the_tpz numeric DEFAULT 0,
    the_tpj numeric DEFAULT 0,
    the_iloscosob numeric DEFAULT 0,
    the_wydajnosc numeric DEFAULT 0,
    the_nodtype integer NOT NULL,
    the_wspstartend_l numeric DEFAULT 1,
    the_wspstartend_m numeric DEFAULT 1,
    the_kosztkooperacji numeric DEFAULT 0,
    the_kosztnah numeric DEFAULT 0,
    the_kosztnaj numeric DEFAULT 0,
    the_opis text,
    ttw_uslugazw integer,
    the_zamawianie_zw_al numeric DEFAULT 0,
    the_zamawianie_zw_am numeric DEFAULT 1,
    the_zamawianie_zw_b numeric DEFAULT 0,
    the_x_licznik numeric,
    the_x_mianownik numeric,
    the_x_wspc numeric,
    ob_idobiektu integer,
    k_idklienta integer,
    the_narzutwydzialowy numeric DEFAULT 0,
    the_zaangazpracownika numeric DEFAULT 100,
    the_wyk_tjn_idjedn integer,
    the_wyk_licznik integer DEFAULT 1,
    the_wyk_mianownik integer DEFAULT 1,
    the_wyk_dokladnosc integer DEFAULT 0,
    the_koopczasreal numeric DEFAULT 0,
    spo_idspinacza integer,
    the_skrypt_przeliczenia text,
    the_kosztstannah numeric DEFAULT 0
);
