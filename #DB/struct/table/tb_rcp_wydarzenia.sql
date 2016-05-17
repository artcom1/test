CREATE TABLE tb_rcp_wydarzenia (
    rcp_idwydarzenia integer NOT NULL,
    rcp_czaswydarzenia timestamp without time zone DEFAULT now() NOT NULL,
    rcp_typwydarzenia integer NOT NULL,
    p_idpracownika integer
);
