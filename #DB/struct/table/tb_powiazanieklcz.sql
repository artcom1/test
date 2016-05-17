CREATE TABLE tb_powiazanieklcz (
    pkl_idpowiazania integer DEFAULT nextval('tb_powiazanieklcz_s'::regclass) NOT NULL,
    k_idklienta integer,
    lk_idczklienta integer,
    pkl_stanowisko text DEFAULT ''::text,
    pkl_tytulstanowisko text DEFAULT ''::text,
    wd_idwplywu integer DEFAULT 0,
    pkl_flaga integer DEFAULT 0
);
