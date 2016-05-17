CREATE TABLE tg_vatytowarow (
    tv_idvatu integer DEFAULT nextval('tg_vatytowarow_s'::regclass) NOT NULL,
    ttw_idtowaru integer NOT NULL,
    pw_idpowiatu integer NOT NULL,
    vk_idvatkraj integer NOT NULL
);
