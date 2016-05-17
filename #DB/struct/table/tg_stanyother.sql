CREATE TABLE tg_stanyother (
    so_idstanu integer DEFAULT nextval(('tg_stanyother_s'::text)::regclass) NOT NULL,
    k_idklienta integer,
    ttw_idtowaru integer,
    so_stan numeric,
    so_data timestamp without time zone DEFAULT now(),
    so_cenanetto numeric,
    so_idwaluty integer
);
