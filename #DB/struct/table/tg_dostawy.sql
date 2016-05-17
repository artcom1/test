CREATE TABLE tg_dostawy (
    dw_iddostawy integer DEFAULT nextval('tg_dostawy_s'::regclass) NOT NULL,
    dw_data date DEFAULT now(),
    dw_opis text,
    dw_flaga integer DEFAULT 0,
    dw_numer integer NOT NULL,
    dw_seria character varying(4),
    dw_rok character varying(2),
    fm_idcentrali integer
);
