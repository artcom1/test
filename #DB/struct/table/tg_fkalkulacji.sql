CREATE TABLE tg_fkalkulacji (
    f_idformuly integer DEFAULT nextval(('tg_fkalkulacji_s'::text)::regclass) NOT NULL,
    ttw_idtowaru integer,
    f_formula text
);
