CREATE TABLE tg_bilety (
    bl_idbiletu integer DEFAULT nextval(('tg_bilety_s'::text)::regclass) NOT NULL,
    bl_dataprodukcji date DEFAULT now(),
    bl_datawydania date,
    bl_datarozagenta date,
    bl_datarozpilota date,
    ttw_idtowaru integer,
    k_idklienta integer,
    bl_idpilota integer,
    p_idpracownika integer,
    bl_pracwydajacy integer,
    bl_pracrozagenta integer,
    bl_pracrozpilota integer,
    bl_ilosc integer,
    bl_cena numeric,
    wl_idwaluty integer,
    bl_przelicznik mpq,
    bl_uwagi text,
    bl_flaga integer,
    bl_numer integer,
    bl_cena0 numeric,
    bl_kod text,
    bl_datauzycia date,
    tel_idelem integer
);