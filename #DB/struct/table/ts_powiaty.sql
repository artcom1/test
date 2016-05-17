CREATE TABLE ts_powiaty (
    pw_idpowiatu integer DEFAULT nextval(('ts_powiaty_s'::text)::regclass) NOT NULL,
    pw_nazwa text NOT NULL,
    pw_wojewodztwo text DEFAULT ''::character varying NOT NULL,
    pw_flaga integer DEFAULT 0,
    pw_idwaluty integer
);
