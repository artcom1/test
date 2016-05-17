CREATE TABLE tb_akcja (
    a_idakcji integer DEFAULT nextval(('tb_akcja_s'::text)::regclass) NOT NULL,
    a_nazwaakcji text NOT NULL,
    ra_idrodzaju integer DEFAULT 0,
    a_datarozpoczecia date DEFAULT now() NOT NULL,
    a_datazakonczenia date,
    a_cel text,
    a_opis text,
    a_opisdokogo text,
    a_wprowadzajacy integer DEFAULT 0,
    a_odpowiedzialny integer DEFAULT 0,
    a_kod character varying(32) DEFAULT ''::character varying,
    a_flaga integer DEFAULT 0,
    a_opiswykonania text,
    a_ocena text,
    a_plankoszt numeric DEFAULT 0
);
