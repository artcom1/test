CREATE TABLE ts_schematy_wymiany (
    sch_id integer DEFAULT nextval('ts_schematy_wymiany_s'::regclass) NOT NULL,
    sch_nazwa text NOT NULL,
    sch_codeuri text,
    sch_settingskey text
);
