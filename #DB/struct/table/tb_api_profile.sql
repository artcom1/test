CREATE TABLE tb_api_profile (
    apc_id integer NOT NULL,
    apc_login text NOT NULL,
    apc_passwordhash text NOT NULL,
    apc_p_idpracownika integer,
    apc_k_idklienta integer,
    apc_flag integer DEFAULT 0 NOT NULL,
    apc_aptype integer NOT NULL
);
