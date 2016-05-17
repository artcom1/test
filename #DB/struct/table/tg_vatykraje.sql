CREATE TABLE tg_vatykraje (
    vk_idvatkraj integer DEFAULT nextval('tg_vatykraje_s'::regclass) NOT NULL,
    ttv_idvatu integer NOT NULL,
    pw_idpowiatu integer NOT NULL,
    vk_validthru date DEFAULT '2079-11-29'::date
);
