CREATE TABLE tp_wypal (
    wp_idwypalu integer DEFAULT nextval(('tp_wypal_s'::text)::regclass) NOT NULL,
    kwe_idelemu integer,
    pp_idpolproduktu integer,
    kwp_idplanu integer,
    wp_nakiedy date,
    wp_iloscplan numeric DEFAULT 0,
    wp_wypalow numeric DEFAULT 0,
    wp_ilosc numeric DEFAULT 0,
    wp_brakow numeric DEFAULT 0,
    p_idpracownika integer,
    wp_datawypalu timestamp without time zone DEFAULT now(),
    wp_pustych numeric DEFAULT 0,
    wp_flaga integer DEFAULT 0,
    wp_czaspracy numeric
);
