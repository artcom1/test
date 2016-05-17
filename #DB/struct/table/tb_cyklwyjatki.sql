CREATE TABLE tb_cyklwyjatki (
    cw_idwyjatku integer DEFAULT nextval('tb_cyklwyjatki_s'::regclass) NOT NULL,
    ck_idcyklu integer NOT NULL,
    cw_newidzdarzenia integer DEFAULT 0,
    cw_lp integer NOT NULL
);
