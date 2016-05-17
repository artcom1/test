CREATE TABLE kh_raportplanelem (
    pe_idelemu integer DEFAULT nextval(('kh_raportplanelem_s'::text)::regclass) NOT NULL,
    pl_idplanu integer NOT NULL,
    re_idelementu integer NOT NULL,
    pe_value numeric DEFAULT 0
);
