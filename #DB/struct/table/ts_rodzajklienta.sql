CREATE TABLE ts_rodzajklienta (
    rk_idrodzajklienta integer DEFAULT nextval(('ts_rodzajklienta_s'::text)::regclass) NOT NULL,
    rk_typrodzaju text NOT NULL,
    rk_parent integer,
    rk_l integer,
    rk_r integer,
    rk_sciezka text
);
