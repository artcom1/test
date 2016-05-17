CREATE TABLE tg_raport (
    r_idraportu integer DEFAULT nextval(('tg_raport_s'::text)::regclass) NOT NULL,
    r_nazwa text,
    r_zapis text,
    r_dane text
);
