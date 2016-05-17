CREATE TABLE tc_variantmap (
    vm_id integer DEFAULT nextval('tc_defaultpdf_s'::regclass) NOT NULL,
    vm_variant uuid NOT NULL,
    pdf_idustawienia integer,
    zpl_idetykiety integer
);
