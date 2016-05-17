CREATE TABLE tb_klbranza (
    kb_idklbranza integer DEFAULT nextval(('tb_klbranza_s'::text)::regclass) NOT NULL,
    k_idklienta integer DEFAULT 0,
    br_idbranzy integer DEFAULT 0
);
