CREATE TABLE tg_tabelavalues (
    vt_idvalue integer DEFAULT nextval(('tg_tabelavalues_s'::text)::regclass) NOT NULL,
    et_idelementux integer NOT NULL,
    et_idelementuy integer NOT NULL,
    tb_idtabeli integer NOT NULL,
    vt_value numeric NOT NULL
);
