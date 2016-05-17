CREATE TABLE kh_wydrukiips_ustawienia (
    wu_idustawienia integer DEFAULT nextval(('kh_wydrukiips_ustawienia_s'::text)::regclass) NOT NULL,
    wu_flaga character varying(20),
    mn_miesiac integer,
    wu_ref integer,
    wu_wartosc numeric,
    wu_data date DEFAULT now()
);
