CREATE TABLE tr_pomiary_wykonanie_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    pw_idpomiarukkw integer NOT NULL
);
