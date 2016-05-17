CREATE TABLE tg_backorder (
    bo_idbackord integer DEFAULT nextval(('tg_backorder_s'::text)::regclass) NOT NULL,
    ttm_idtowmag integer,
    bo_iloscf numeric DEFAULT 0 NOT NULL,
    bo_powod integer DEFAULT 0,
    tel_idelemsrc integer,
    rc_idruchusrc integer,
    bo_flaga integer DEFAULT 0,
    knr_idelemusrc integer,
    kwh_idheadusrc integer,
    bo_data date DEFAULT now(),
    zl_idzlecenia integer,
    pz_idplanusrc integer,
    bo_datautw timestamp with time zone DEFAULT now()
);
