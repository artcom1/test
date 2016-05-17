CREATE TABLE tm_customcols (
    cc_id integer DEFAULT nextval('tm_customcols_s'::regclass) NOT NULL,
    cc_colid uuid NOT NULL,
    cc_ctrlid uuid NOT NULL,
    cc_qcid uuid NOT NULL,
    cc_code text,
    cc_title text,
    cc_code_dokladnosc text,
    cc_code_color text
);
