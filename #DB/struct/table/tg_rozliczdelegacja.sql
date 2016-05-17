CREATE TABLE tg_rozliczdelegacja (
    rd_idrozliczenia integer DEFAULT nextval('tg_rozliczdelegacja_s'::regclass) NOT NULL,
    rd_numerobcy text,
    rd_data timestamp with time zone,
    rd_datazak timestamp with time zone,
    rd_ilosc numeric DEFAULT 1,
    rd_cena numeric DEFAULT 0,
    rd_opis text,
    rd_flaga integer DEFAULT 0,
    rd_kurswaluty mpq DEFAULT '1'::mpq,
    rd_kwota numeric DEFAULT 0,
    rd_kwotapln numeric DEFAULT 0,
    rd_miejsca text,
    rd_miejscb text,
    lt_idtransportu integer NOT NULL,
    kd_idkartoteki integer NOT NULL,
    k_idklienta integer DEFAULT 0,
    wl_idwaluty integer DEFAULT 1,
    tr_idtrans integer
);
