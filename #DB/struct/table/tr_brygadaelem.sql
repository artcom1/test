CREATE TABLE tr_brygadaelem (
    be_idbrygadaelemu integer DEFAULT nextval('tr_brygadaelem_s'::regclass) NOT NULL,
    ob_idobiektu integer NOT NULL,
    p_idpracownika integer NOT NULL,
    be_datamod timestamp without time zone DEFAULT now()
);
