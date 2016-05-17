CREATE TABLE ts_kontavoip (
    voip_idkonta integer DEFAULT nextval('ts_kontavoip_s'::regclass) NOT NULL,
    voip_username text NOT NULL,
    voip_password text NOT NULL,
    voip_authname text,
    voip_domain text NOT NULL,
    voip_proxy text
);
