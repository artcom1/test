CREATE TABLE tc_powiazaniastatusowlp (
    psl_idpowiazania integer DEFAULT nextval('tc_powiazaniastatusowlp_s'::regclass) NOT NULL,
    sp_idspedytora integer NOT NULL,
    psl_remotestatus text NOT NULL,
    st_idstatusu integer NOT NULL
);
