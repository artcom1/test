CREATE TABLE ts_pcns (
    pcn_id integer DEFAULT nextval('ts_pcns_s'::regclass) NOT NULL,
    pcn_numer integer NOT NULL,
    pcn_nazwa text,
    pcn_jalttype smallint DEFAULT 0
);
