CREATE TABLE ts_dzialy (
    dz_iddzialu integer DEFAULT nextval(('ts_dzialy_s'::text)::regclass) NOT NULL,
    dz_nazwa text NOT NULL,
    dz_opis text NOT NULL,
    dz_parent integer,
    dz_shortcut text
);
