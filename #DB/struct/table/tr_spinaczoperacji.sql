CREATE TABLE tr_spinaczoperacji (
    spo_idspinacza integer DEFAULT nextval('tr_spinaczoperacji_s'::regclass) NOT NULL,
    ob_idobiektu integer,
    spo_datautworzenia timestamp with time zone DEFAULT now(),
    spo_datazamkniecia timestamp with time zone,
    spo_data timestamp with time zone DEFAULT now(),
    spo_flaga integer DEFAULT 0,
    th_idtechnologii integer,
    spo_kolor integer DEFAULT (power((2)::double precision, (24)::double precision) - (1)::double precision),
    spo_opis text,
    kwe_idelemudef integer
);
