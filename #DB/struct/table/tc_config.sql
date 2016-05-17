CREATE TABLE tc_config (
    cf_idconf integer DEFAULT nextval(('tc_config_s'::text)::regclass) NOT NULL,
    cf_tabela text,
    cf_opis text,
    cf_defvalue text,
    cf_lastchange timestamp without time zone DEFAULT now()
);
