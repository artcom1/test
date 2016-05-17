CREATE TABLE tg_kpoelem (
    kpe_idelemu integer DEFAULT nextval('tg_kpoelem_s'::regclass) NOT NULL,
    kpo_idheadu integer,
    ttw_idtowaru integer,
    kpe_iloscf numeric,
    kpe_waga numeric,
    kpe_wagaprzelicznik numeric,
    tjn_idjedn integer,
    kpe_opis text
);
