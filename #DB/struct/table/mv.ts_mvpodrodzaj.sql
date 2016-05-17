CREATE TABLE ts_mvpodrodzaj (
    mvp_id integer DEFAULT nextval('mvmultivalues_s'::regclass) NOT NULL,
    mvs_id integer NOT NULL,
    mvp_notpodrodzaj integer NOT NULL,
    mvp_moddate timestamp without time zone DEFAULT now()
);
