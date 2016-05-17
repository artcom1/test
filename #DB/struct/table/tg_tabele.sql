CREATE TABLE tg_tabele (
    tb_idtabeli integer DEFAULT nextval(('tg_tabele_s'::text)::regclass) NOT NULL,
    tb_nazwa text,
    wl_idwaluty integer
);
