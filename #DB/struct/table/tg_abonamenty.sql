CREATE TABLE tg_abonamenty (
    ab_idabonamentu integer DEFAULT nextval(('tg_abonamenty_s'::text)::regclass) NOT NULL,
    ra_idrodzaju integer,
    p_idpracownika integer,
    k_idklienta integer,
    ab_flaga integer DEFAULT 0,
    ab_dataod date DEFAULT now(),
    ab_datado date DEFAULT now(),
    ab_opis text,
    ab_numer integer,
    ab_seria character varying(4),
    ab_rok character varying(2),
    fm_idcentrali integer
);
