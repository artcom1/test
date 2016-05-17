CREATE TABLE tu_impplat (
    ipp_id integer DEFAULT nextval('tu_impplat_s'::regclass) NOT NULL,
    ipp_typ text,
    ipp_name text,
    ipp_separator text,
    ipp_skipheader boolean DEFAULT false,
    ipp_encoding integer,
    bk_idbanku integer
);
