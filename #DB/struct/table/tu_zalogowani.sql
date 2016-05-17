CREATE TABLE tu_zalogowani (
    zs_idzalogowani integer DEFAULT nextval(('tu_zalogowani_s'::text)::regclass) NOT NULL,
    zs_data date DEFAULT now(),
    zs_nazwa text
);
