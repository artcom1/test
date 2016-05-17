CREATE TABLE tg_wynagrodzenia (
    wg_idwynagrodzenia integer DEFAULT nextval('tg_wynagrodzenia_s'::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    wg_hashcode integer NOT NULL,
    wg_value numeric DEFAULT 0,
    wg_flaga integer DEFAULT 0,
    wg_datawyliczenia date DEFAULT now(),
    wg_datarozliczenia date,
    wg_datazaplacenia date,
    wg_uwagi text,
    fm_idcentrali integer,
    wg_istmp boolean DEFAULT false
);
