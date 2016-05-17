CREATE TABLE tg_eltabeli (
    et_idelementu integer DEFAULT nextval(('tg_eltabeli_s'::text)::regclass) NOT NULL,
    tb_idtabeli integer,
    et_flaga integer DEFAULT 0,
    et_key numeric NOT NULL
);
