CREATE TABLE kh_raportplan (
    pl_idplanu integer DEFAULT nextval(('kh_raportplan_s'::text)::regclass) NOT NULL,
    pl_nazwa text,
    rp_idraportu integer NOT NULL,
    pl_flaga integer DEFAULT 0
);
