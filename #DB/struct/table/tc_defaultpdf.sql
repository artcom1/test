CREATE TABLE tc_defaultpdf (
    dpdf_id integer DEFAULT nextval('tc_defaultpdf_s'::regclass) NOT NULL,
    pdf_idustawienia integer NOT NULL,
    k_idklienta integer
);
