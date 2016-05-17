CREATE TABLE tu_uprawnienia (
    u_iduprawnienia integer DEFAULT nextval(('tu_uprawnienia_s'::text)::regclass) NOT NULL,
    u_nazwa text,
    u_ref text,
    p_idpracownika integer,
    v_idversi integer
);
