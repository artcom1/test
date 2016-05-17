CREATE TABLE tg_magazyny (
    tmg_idmagazynu integer DEFAULT nextval(('tg_magazyny_s'::text)::regclass) NOT NULL,
    tmg_nazwa text DEFAULT ''::text,
    tmg_opis text DEFAULT ''::text,
    tmg_kontoks text,
    fm_index integer,
    tmg_iln text,
    k_idklienta integer,
    tmg_kod text,
    tmg_flaga integer DEFAULT 0,
    opk_idosrodka integer,
    fm_idcentrali integer,
    tmg_isfortk smallint DEFAULT 0,
    tmg_idmagazynufortk integer,
    tmg_wartosc numeric,
    scr_bigsimulation integer,
    zl_foridzlecenia integer,
    ob_foridobiektu integer,
    p_foridpracownika integer,
    CONSTRAINT checkmagazynex CHECK (((tmg_isfortk <> 4) OR ((k_idklienta IS NOT NULL) OR (zl_foridzlecenia IS NOT NULL) OR (ob_foridobiektu IS NOT NULL) OR (p_foridpracownika IS NOT NULL)))),
    CONSTRAINT checkmagazynex2 CHECK (((((COALESCE(k_idklienta, 0) + COALESCE(zl_foridzlecenia, 0)) + COALESCE(ob_foridobiektu, 0)) + COALESCE(p_foridpracownika, 0)) = (((COALESCE(k_idklienta, 1) * COALESCE(zl_foridzlecenia, 1)) * COALESCE(ob_foridobiektu, 1)) * COALESCE(p_foridpracownika, 1))))
);