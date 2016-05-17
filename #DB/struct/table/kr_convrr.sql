CREATE TABLE kr_convrr (
    cvr_rrid integer DEFAULT nextval('kr_conv_s'::regclass) NOT NULL,
    pp_idplatelem integer,
    cvr_lid integer,
    cvr_rid integer,
    cvr_valuel numeric,
    cvr_valuer numeric,
    typ integer,
    p_idpracownika integer,
    cvr_datarozliczenia date
);
