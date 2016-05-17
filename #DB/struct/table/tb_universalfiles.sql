CREATE TABLE tb_universalfiles (
    ufl_id integer DEFAULT nextval('tb_universalfiles_s'::regclass) NOT NULL,
    tag_id integer NOT NULL,
    ufl_ref integer NOT NULL,
    ufl_status integer,
    ufl_flag integer DEFAULT 0 NOT NULL,
    ufl_ownertype integer NOT NULL,
    ufl_ownerid integer NOT NULL
);
