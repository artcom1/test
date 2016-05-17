CREATE TABLE tm_simdlamiejsca (
    sdm_id integer DEFAULT nextval('tm_simdlamiejsca_s'::regclass) NOT NULL,
    sc_sid integer DEFAULT vendo.tv_mysessionpid() NOT NULL,
    sc_simid integer NOT NULL,
    ttw_idtowaru integer NOT NULL,
    prt_idpartiipz integer,
    ilosc numeric NOT NULL,
    sdm_qdiv text
);
