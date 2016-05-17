CREATE TABLE tr_przeliczeniestruktur (
    psk_isprzeliczenia integer DEFAULT nextval('tr_przeliczeniestruktur_s'::regclass) NOT NULL,
    psk_nazwa text,
    psk_flaga integer DEFAULT 0
);
