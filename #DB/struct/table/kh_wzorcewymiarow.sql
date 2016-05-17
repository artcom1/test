CREATE TABLE kh_wzorcewymiarow (
    wzw_idwzorca integer DEFAULT nextval('kh_wzorcewymiarow_s'::regclass) NOT NULL,
    we_idelementu integer,
    wms_idwymiaru integer,
    wzw_value numeric,
    wzw_valuetype integer,
    wz_idwzorca integer,
    wzw_whatbydetails integer DEFAULT 0,
    wzw_alwaysvalue integer,
    kwl_id integer,
    kwl_nrkonta smallint
);
