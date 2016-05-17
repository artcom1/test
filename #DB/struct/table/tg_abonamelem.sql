CREATE TABLE tg_abonamelem (
    ae_idelemu integer DEFAULT nextval(('tg_abonamelem_s'::text)::regclass) NOT NULL,
    ab_idabonamentu integer,
    ttw_idtowaru integer,
    ae_flaga integer DEFAULT 0,
    ae_ilosc numeric DEFAULT 1,
    ae_datawpisu date DEFAULT now(),
    ae_opis text,
    ae_nazwa text,
    ob_idobiektu integer
);
