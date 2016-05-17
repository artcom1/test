CREATE TABLE tp_mozliwestanowiska (
    ms_idmozliwosci integer DEFAULT nextval(('tp_mozliwestanowiska_s'::text)::regclass) NOT NULL,
    ob_idobiektu integer NOT NULL,
    ep_idetapu integer NOT NULL,
    ms_tpj numeric DEFAULT 0,
    ms_wydajnosc numeric DEFAULT 0,
    ms_tpz numeric DEFAULT 0,
    ms_iloscosob numeric DEFAULT 0
);
