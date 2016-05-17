CREATE TABLE tc_ustawieniapdf (
    pdf_idustawienia integer DEFAULT nextval(('tc_ustawieniapdf_s'::text)::regclass) NOT NULL,
    pdf_hashcode text DEFAULT '0'::text,
    pdf_version integer DEFAULT 0,
    pdf_xml text,
    pdf_newhash uuid,
    pdf_code text,
    pdf_nazwa text
);
