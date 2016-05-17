CREATE TABLE tg_kursywalut (
    kw_idkursu integer DEFAULT nextval('tg_kursywalut_s'::regclass) NOT NULL,
    tw_idtabeli integer NOT NULL,
    wl_idwaluty integer NOT NULL,
    kw_przelicznik mpq DEFAULT '1'::mpq NOT NULL,
    kw_data date DEFAULT now(),
    kw_islast boolean DEFAULT false,
    kw_nrtabelikursu text
);
