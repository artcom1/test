CREATE TABLE tg_powiazanieplanu (
    pw_idpowiazania integer DEFAULT nextval('tg_powiazanieplanu_s'::regclass) NOT NULL,
    pz_idplanu integer NOT NULL,
    pw_ile integer NOT NULL
);
