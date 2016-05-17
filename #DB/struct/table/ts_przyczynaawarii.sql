CREATE TABLE ts_przyczynaawarii (
    pa_idawarii integer DEFAULT nextval('ts_przyczynaawarii_s'::regclass) NOT NULL,
    pa_nazwa text,
    pa_typ integer
);
