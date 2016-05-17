CREATE TABLE kr_kompensaty (
    km_idkompensaty integer DEFAULT nextval('kr_rozrachunki_s'::regclass) NOT NULL,
    k_idklienta integer,
    km_numer integer NOT NULL,
    km_rok character varying(2) NOT NULL,
    km_saldown numeric NOT NULL,
    km_saldoma numeric NOT NULL,
    km_datakomp date DEFAULT now(),
    wl_idwaluty integer
);
