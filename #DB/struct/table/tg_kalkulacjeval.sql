CREATE TABLE tg_kalkulacjeval (
    kv_idwartosci integer DEFAULT nextval(('tg_kalkulacjeval_s'::text)::regclass) NOT NULL,
    tel_idelem integer,
    kv_lp integer DEFAULT 0,
    kv_flaga integer DEFAULT 0,
    kv_value text DEFAULT ''::text,
    kk_idkalk integer,
    es_idelem integer,
    tgr_idgrupy integer,
    tb_idtabeli integer,
    kv_ilosc numeric,
    tr_idtrans integer,
    pz_idplanu integer,
    zl_idzlecenia integer,
    sl_idslownika integer,
    kv_nazwa text,
    kv_opis text,
    sw_idswiadectwa integer
);
