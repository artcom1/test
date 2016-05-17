CREATE TABLE ts_branze (
    br_idbranzy integer DEFAULT nextval(('ts_branze_s'::text)::regclass) NOT NULL,
    br_nazwa text NOT NULL,
    br_opis text NOT NULL,
    pf_idprofilu integer
);
