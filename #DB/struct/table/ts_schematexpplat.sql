CREATE TABLE ts_schematexpplat (
    ep_idschematu integer DEFAULT nextval(('ts_schematexpplat_s'::text)::regclass) NOT NULL,
    ep_nazwa text,
    ep_nrkonta text,
    ep_nrbanku text,
    ep_nazwafirmy text,
    bk_idbanku integer,
    ep_nrcif text
);
