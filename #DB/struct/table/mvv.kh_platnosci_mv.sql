CREATE TABLE kh_platnosci_mv (
    nmv_id integer DEFAULT nextval('mv.mvmultivalues_s'::regclass) NOT NULL,
    pl_idplatnosc integer NOT NULL
);
