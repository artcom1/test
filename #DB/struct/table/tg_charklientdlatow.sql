CREATE TABLE tg_charklientdlatow (
    ckdt_idkartoteki integer DEFAULT nextval('tg_charklientdlatow_s'::regclass) NOT NULL,
    ckdt_ja_idjednostki integer,
    ckdt_ttw_idtowaru integer NOT NULL,
    ckdt_k_idklienta integer NOT NULL,
    ckdt_ean text,
    ckdt_nazwauklienta text,
    ckdt_koduklienta text,
    ckdt_tda_idtypu integer DEFAULT 0,
    ckdt_flaga integer DEFAULT 0
);
