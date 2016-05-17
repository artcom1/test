CREATE TABLE tr_mrppalety (
    mrpp_idpalety integer DEFAULT nextval('tr_mrppalety_s'::regclass) NOT NULL,
    k_idklienta integer,
    mrpp_znacznikstart text,
    mrpp_znacznikstop text,
    mrpp_data timestamp with time zone DEFAULT now(),
    mrpp_flaga integer DEFAULT 0,
    p_idpracownika integer,
    mm_idmiejsca integer,
    tmg_idmagazynu integer,
    mrpp_sscc text,
    fm_idcentrali integer NOT NULL
);
