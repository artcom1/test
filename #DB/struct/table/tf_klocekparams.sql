CREATE TABLE tf_klocekparams (
    fp_idparamu integer DEFAULT nextval('tf_klocekparams_s'::regclass) NOT NULL,
    fr_idraportu integer,
    fk_idklocka integer NOT NULL,
    fp_type integer NOT NULL,
    fp_operator integer DEFAULT 0 NOT NULL,
    fp_valueastxt text,
    fk_idklocka_in integer,
    fr_idraportu_in integer,
    fp_typetid text
);
