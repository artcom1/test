CREATE TABLE tg_idpartiitocalc (
    idc_id integer DEFAULT nextval('tg_idpartiitocalc_s'::regclass) NOT NULL,
    tel_idelem integer,
    tex_idelem integer,
    prt_idpartii integer
);
