CREATE TABLE to_zmianacenypz (
    ocpz_idorder integer DEFAULT nextval('to_orders_s'::regclass) NOT NULL,
    tel_idelem integer,
    ocpz_newcena numeric,
    ocpz_cenawaluta integer,
    ocpz_newilosc numeric
);
