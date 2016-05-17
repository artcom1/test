CREATE TABLE tf_raportklocki (
    fk_idklocka integer DEFAULT nextval('tf_raportklocki_s'::regclass) NOT NULL,
    fr_idraportu integer,
    fk_parent integer,
    fk_type integer NOT NULL,
    fk_nazwa text,
    fk_relation integer DEFAULT 0 NOT NULL,
    fk_retvaluetype integer
);
