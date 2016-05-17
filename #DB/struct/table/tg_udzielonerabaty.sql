CREATE TABLE tg_udzielonerabaty (
    ur_idrabatu integer DEFAULT nextval(('tg_udzielonerabaty_s'::text)::regclass) NOT NULL,
    tel_idelem integer,
    ur_rabat numeric,
    ur_rabatbtr numeric
);
