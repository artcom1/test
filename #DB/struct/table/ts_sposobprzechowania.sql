CREATE TABLE ts_sposobprzechowania (
    sp_idprzechow integer DEFAULT nextval('ts_sposobprzechowania_s'::regclass) NOT NULL,
    sp_nazwa text
);
