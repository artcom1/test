CREATE TABLE tg_podczepieniadoetapow (
    pde_idpodczepienia integer DEFAULT nextval(('tg_podczepieniadoetapow_s'::text)::regclass) NOT NULL,
    sz_idetapu integer,
    p_idpracownika integer,
    pde_ref integer,
    pde_typref integer,
    pde_date timestamp without time zone DEFAULT now()
);
