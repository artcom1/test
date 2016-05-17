CREATE TABLE tu_impplatelem (
    ipe_idelem integer DEFAULT nextval('tu_impplat_s'::regclass) NOT NULL,
    ipp_id integer,
    ipe_order integer,
    ipe_column text
);
