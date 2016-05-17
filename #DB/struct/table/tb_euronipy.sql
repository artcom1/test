CREATE TABLE tb_euronipy (
    eun_ideuronipu integer DEFAULT nextval('tb_euronipy_s'::regclass) NOT NULL,
    eun_nip text NOT NULL,
    p_idpracownika integer,
    eun_data timestamp without time zone DEFAULT now(),
    k_idklienta integer,
    eun_flaga integer DEFAULT 0
);
