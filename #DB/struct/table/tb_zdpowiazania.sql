CREATE TABLE tb_zdpowiazania (
    zp_idpowiazania integer DEFAULT nextval(('tb_zdpowiazania_s'::text)::regclass) NOT NULL,
    zd_idzdarzenia integer NOT NULL,
    zp_idref integer NOT NULL,
    zp_datatype integer NOT NULL,
    zp_flaga integer DEFAULT 0
);
