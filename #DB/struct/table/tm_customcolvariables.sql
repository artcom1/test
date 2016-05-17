CREATE TABLE tm_customcolvariables (
    ccv_varid uuid NOT NULL,
    cc_colid uuid NOT NULL,
    ccv_varname text,
    ccv_srccol uuid NOT NULL,
    ccv_srczmienna uuid NOT NULL,
    ccv_genaddr text
);
