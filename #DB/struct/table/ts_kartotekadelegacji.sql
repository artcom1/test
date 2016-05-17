CREATE TABLE ts_kartotekadelegacji (
    kd_idkartoteki integer DEFAULT nextval('ts_kartotekadelegacji_s'::regclass) NOT NULL,
    kd_nazwa text,
    kd_priorytet integer DEFAULT 0,
    kd_flaga integer DEFAULT 0,
    kd_defilosc numeric DEFAULT 0,
    kd_defcena numeric DEFAULT 0,
    wl_idwaluty integer DEFAULT 1,
    ttw_idtowaru integer
);
