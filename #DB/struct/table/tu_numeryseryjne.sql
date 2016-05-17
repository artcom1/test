CREATE TABLE tu_numeryseryjne (
    ns_idnumeru integer DEFAULT nextval(('tu_numeryseryjne_s'::text)::regclass) NOT NULL,
    ns_nazwa text,
    ns_numer text,
    p_idpracownika integer,
    ns_data timestamp with time zone DEFAULT now(),
    ns_numerroz text
);
