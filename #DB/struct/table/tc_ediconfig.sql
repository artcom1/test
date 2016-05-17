CREATE TABLE tc_ediconfig (
    edi_idkonta integer DEFAULT nextval(('tc_ediconfig_s'::text)::regclass) NOT NULL,
    tr_seria character varying(4),
    k_idklienta integer,
    edi_nazwa text,
    edi_znaczenie integer DEFAULT 0,
    tmg_idmagazynu integer
);
