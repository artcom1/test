CREATE TABLE tg_hotelezlecen (
    ht_idhotelu integer DEFAULT nextval(('tg_hotelezlecen_s'::text)::regclass) NOT NULL,
    zl_idzlecenia integer,
    k_idklienta integer,
    ht_iloscosob integer DEFAULT 0,
    ht_iloscnoclegow integer,
    p_idpracownika integer,
    ht_dataod date,
    ht_datado date,
    ht_jedynki integer,
    ht_dwojki integer,
    ht_trojki integer,
    ht_czworki integer,
    ht_flaga integer DEFAULT 0,
    st_idstatusu integer,
    ht_opis text,
    wl_idwaluty integer,
    ht_wartosc numeric DEFAULT 0
);
