CREATE TABLE tr_pomiary_wykonanie (
    pw_idpomiarukkw integer DEFAULT nextval('tr_pomiary_wykonanie_s'::regclass) NOT NULL,
    pd_iddefinicji integer NOT NULL,
    p_idpracownika integer NOT NULL,
    pw_data timestamp with time zone DEFAULT now() NOT NULL,
    kwh_idheadu integer NOT NULL,
    kwe_idelemu integer,
    knw_idelemu integer,
    pw_opis text,
    pw_flaga integer DEFAULT 0,
    pw_nroperacji numeric DEFAULT 0 NOT NULL,
    pw_nrmierzonejsztuki numeric DEFAULT 0 NOT NULL,
    ttw_idnarzedzia1 integer,
    ttw_idnarzedzia2 integer,
    pw_typ integer DEFAULT 0,
    pw_numval_min numeric,
    pw_numval_max numeric,
    pw_numval_dokladnosc integer,
    sl_idslownika integer,
    pw_numval_przed_kj numeric,
    pw_intval_przed_kj integer,
    es_idelem_przed_kj integer,
    pw_komentarz_przed_kj text,
    pw_numval_po_kj numeric,
    pw_intval_po_kj integer,
    es_idelem_po_kj integer,
    pw_komentarz_po_kj text,
    p_idpracownika_kj integer,
    pw_data_kj timestamp with time zone,
    pw_nazwa text,
    pw_kod text
);
