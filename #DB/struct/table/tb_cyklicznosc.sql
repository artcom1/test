CREATE TABLE tb_cyklicznosc (
    ck_idcyklu integer DEFAULT nextval('tb_cyklicznosc_s'::regclass) NOT NULL,
    zd_idzdarzenia integer NOT NULL,
    ck_datazakonczenia timestamp with time zone,
    ck_okres interval
);
