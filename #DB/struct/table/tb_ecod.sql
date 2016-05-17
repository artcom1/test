CREATE TABLE tb_ecod (
    ecod_id integer DEFAULT nextval(('tb_ecod_s'::text)::regclass) NOT NULL,
    tr_idtrans integer,
    ecod_flaga integer DEFAULT 0,
    ecod_symbol text,
    ecod_doctype text NOT NULL,
    ecod_dataimp date DEFAULT now(),
    ecod_fct integer,
    ecod_typaplikacji integer NOT NULL
);
