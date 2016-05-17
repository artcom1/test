CREATE TABLE tb_role (
    rol_id integer DEFAULT nextval('tb_role_s'::regclass) NOT NULL,
    rol_name text NOT NULL,
    rol_description text,
    rol_flag integer DEFAULT 0 NOT NULL
);
