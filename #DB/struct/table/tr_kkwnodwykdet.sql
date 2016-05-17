CREATE TABLE tr_kkwnodwykdet (
    kwd_idelemu integer DEFAULT nextval(('tr_kkwnodwykdet_s'::text)::regclass) NOT NULL,
    knw_idelemu integer,
    p_idpracownika integer,
    kwd_rbh numeric DEFAULT 0,
    kwd_flaga integer DEFAULT 0,
    kwd_datastart timestamp with time zone,
    kwd_dataend timestamp with time zone,
    kwd_czaswolny numeric DEFAULT 0,
    kwe_idelemu integer,
    kwh_idheadu integer
);
