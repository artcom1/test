CREATE TABLE tp_etappolproduktu (
    ep_idetapu integer DEFAULT nextval(('tp_etappolproduktu_s'::text)::regclass) NOT NULL,
    ek_idetapu integer,
    ep_lp integer,
    pp_idpolproduktu integer,
    ep_opis text,
    ep_flaga integer DEFAULT 0,
    ep_prbrakow numeric DEFAULT 0.00
);
