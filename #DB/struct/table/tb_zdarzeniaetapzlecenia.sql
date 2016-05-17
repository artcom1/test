CREATE TABLE tb_zdarzeniaetapzlecenia (
    zez_id integer DEFAULT nextval('tb_zdarzeniaetapzlecenia_s'::regclass) NOT NULL,
    szl_idstatusu_eps integer NOT NULL,
    zez_typzlecenia integer NOT NULL,
    zez_rodzajzlecenia integer NOT NULL,
    szl_idstatusu_ezl integer NOT NULL
);
