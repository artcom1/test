CREATE TABLE tm_uprawnienia (
    tu_iduprawnienia integer DEFAULT nextval(('tm_uprawnienia_s'::text)::regclass) NOT NULL,
    st_idstanowiska integer,
    p_idpracownika integer,
    tu_kod text DEFAULT ''::character varying,
    tu_tabela text DEFAULT ''::text
);
