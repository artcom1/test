CREATE TABLE tg_kartypremiowe (
    kr_idkarty integer DEFAULT nextval('tg_kartypremiowe_s'::regclass) NOT NULL,
    k_idklienta integer NOT NULL,
    kr_nrkarty text NOT NULL,
    kr_uwagi text DEFAULT ''::text,
    kr_punktow integer DEFAULT 0 NOT NULL,
    kr_flaga integer DEFAULT 0 NOT NULL
);
