CREATE TABLE tg_etapyzlecen (
    sz_idetapu integer DEFAULT nextval(('tg_etapyzlecen_s'::text)::regclass) NOT NULL,
    zl_idzlecenia integer,
    p_idpracownika integer,
    szl_idstatusu integer,
    sz_komentarz text,
    sz_data abstime DEFAULT now(),
    sz_datawykonania date,
    sz_status integer
);
