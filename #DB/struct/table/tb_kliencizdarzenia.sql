CREATE TABLE tb_kliencizdarzenia (
    kzd_idklientazd integer DEFAULT nextval(('tb_kliencizdarzenia_s'::text)::regclass) NOT NULL,
    k_idklienta integer,
    zd_idzdarzenia integer NOT NULL,
    lk_idczklienta integer DEFAULT 0,
    kzd_flaga integer DEFAULT 0,
    kzd_opis text
);
