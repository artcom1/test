CREATE TABLE tf_raport (
    fr_idraportu integer DEFAULT nextval('tf_raport_s'::regclass) NOT NULL,
    fr_nazwa text,
    fr_rettype integer NOT NULL,
    fr_relation integer DEFAULT 1
);
