CREATE TABLE tb_googleaccounts (
    gga_id integer DEFAULT nextval('tb_googleaccounts_s'::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    gga_username text NOT NULL,
    gga_token text NOT NULL,
    gga_settings text[] DEFAULT '[0:0]={''''}'::text[] NOT NULL,
    gga_flag integer DEFAULT 0 NOT NULL,
    gga_lockby integer
);
