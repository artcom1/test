CREATE TABLE tp_polprodukty (
    pp_idpolproduktu integer DEFAULT nextval(('tp_polprodukty_s'::text)::regclass) NOT NULL,
    pp_nazwa text,
    pp_kod text,
    pp_stan numeric DEFAULT 0,
    pp_flaga integer DEFAULT 0,
    zl_idzlecenia integer,
    ttw_idtowaru integer,
    pp_waga numeric DEFAULT 0,
    pp_onwypal numeric,
    pp_wartosc numeric,
    tjn_idjedn integer
);
