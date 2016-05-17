CREATE TABLE tg_powiazaniepaczek (
    pp_idpowpack integer DEFAULT nextval('tg_powiazaniepaczek_s'::regclass) NOT NULL,
    pk_idpaczki integer NOT NULL,
    pp_ile integer NOT NULL
);
