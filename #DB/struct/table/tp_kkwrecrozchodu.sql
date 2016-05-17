CREATE TABLE tp_kkwrecrozchodu (
    rr_idskladnika integer DEFAULT nextval(('tp_kkwrecrozchodu_s'::text)::regclass) NOT NULL,
    ep_idetapu integer NOT NULL,
    rr_idtowaru integer,
    ttw_idtowaru integer,
    rr_ilosc numeric DEFAULT 0,
    tmg_idmagazynu integer,
    rr_recna numeric DEFAULT 1,
    rr_wspbrakow integer DEFAULT 0
);
