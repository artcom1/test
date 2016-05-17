CREATE TABLE ts_zwrotgrzeczn (
    zg_idzwrotu integer DEFAULT nextval(('ts_zwrotgrzeczn_s'::text)::regclass) NOT NULL,
    zg_opiszwrotu text NOT NULL
);
