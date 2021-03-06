CREATE TABLE tb_kontakt (
    m_idkontaktu integer DEFAULT nextval(('tb_kontakt_s'::text)::regclass) NOT NULL,
    lk_idczklienta integer DEFAULT 0,
    a_idakcji integer DEFAULT 0,
    p_idpracownika integer DEFAULT 0,
    sl_idspotkania integer DEFAULT 0,
    rk_idrodzajkontaktu integer DEFAULT 0,
    tp_idtypspotkania integer DEFAULT 0,
    m_gdziespotkanie text NOT NULL,
    m_godzinaspotkania timestamp with time zone NOT NULL,
    m_celspotkania text NOT NULL,
    m_coprzygotowac text,
    m_wykonanie boolean,
    m_przyczynaniewykonania text,
    m_datawykonania timestamp with time zone,
    m_opisspotkania text,
    ef_idefektu integer DEFAULT 0,
    m_nic text,
    pc_idprocesu integer,
    m_pracinicj boolean DEFAULT false,
    m_pwprowadzajacy integer DEFAULT 0,
    m_pwykonujacy integer DEFAULT 0,
    m_datawpr date DEFAULT now(),
    m_celzrealizowany boolean DEFAULT false,
    k_idklienta integer DEFAULT 0,
    m_flaga smallint DEFAULT 0,
    sc_idsciezki integer,
    sc_pozycjawsciezce integer,
    m_czasspotkania numeric,
    zl_idzlecenia integer
);
