CREATE TABLE ts_multivalfiltr (
    mvf_idfiltru integer DEFAULT nextval('ts_multivalfiltr_s'::regclass) NOT NULL,
    mvs_id integer NOT NULL,
    mvf_dtype integer NOT NULL,
    mvf_defvalue integer,
    mvf_valuefromparent boolean DEFAULT false NOT NULL
);
