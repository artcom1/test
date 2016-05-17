CREATE TABLE tp_kkwelem (
    kwe_idelemu integer DEFAULT nextval(('tp_kkwelem_s'::text)::regclass) NOT NULL,
    kwh_idheadu integer,
    kwe_flaga integer DEFAULT 0,
    kwe_stanst numeric DEFAULT 0,
    kwe_fromother numeric DEFAULT 0,
    kwe_brakow numeric DEFAULT 0,
    kwe_added numeric DEFAULT 0,
    kwe_tonext numeric DEFAULT 0,
    kwe_pozostalo numeric DEFAULT 0,
    kwe_prevelem integer,
    p_idpracownika integer,
    kwe_data timestamp without time zone DEFAULT now(),
    ek_idetapu integer NOT NULL,
    pp_idpolproduktu integer NOT NULL,
    ttw_idtowaru integer,
    ep_idetapu integer
);
