CREATE TABLE tb_rcp_agregacja (
    rcpa_idagregacji integer NOT NULL,
    p_idpracownika integer,
    rcpa_data date NOT NULL,
    rcpa_sumy_czasu interval[],
    rcpa_ostatni_tryb integer,
    rcpa_ostatni_klik timestamp without time zone,
    rcpa_wejscie timestamp without time zone,
    rcpa_wyjscie timestamp without time zone,
    rcpa_zmiana integer DEFAULT 1,
    rcpa_flaga integer
);
