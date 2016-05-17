CREATE TABLE tg_vaty (
    ttv_idvatu integer DEFAULT nextval(('tg_vaty_s'::text)::regclass) NOT NULL,
    ttv_vat numeric DEFAULT 22
);
