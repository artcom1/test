CREATE TABLE tg_stanytowmagazyn (
    stm_idstanu integer DEFAULT nextval(('tg_stanytowmagazyn_s'::text)::regclass) NOT NULL,
    ttw_idtowaru integer,
    tmg_idmagazynu integer,
    stm_stanmin numeric,
    stm_stanmax numeric,
    stm_krotnoscgen numeric,
    stm_limitjest integer,
    stm_minwielzam numeric DEFAULT 0,
    mm_idmiejsca integer,
    stm_defiloscmode smallint DEFAULT 0
);
