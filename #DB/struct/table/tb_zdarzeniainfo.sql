CREATE TABLE tb_zdarzeniainfo (
    zdi_id integer DEFAULT nextval('tb_zdarzeniainfo_s'::regclass) NOT NULL,
    zdi_code text NOT NULL,
    zdi_name text NOT NULL,
    zdi_mflag integer[] DEFAULT '[0:0]={0}'::integer[] NOT NULL,
    zdi_mvalues text[] DEFAULT ARRAY[]::text[] NOT NULL
);
