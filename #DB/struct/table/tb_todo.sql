CREATE TABLE tb_todo (
    td_idtodo integer DEFAULT nextval(('tb_todo_s'::text)::regclass) NOT NULL,
    td_datawpr timestamp with time zone DEFAULT now() NOT NULL,
    td_zlecajacy integer DEFAULT 0,
    td_komu integer DEFAULT 0,
    td_opis text NOT NULL,
    td_nakiedy date NOT NULL,
    td_status integer DEFAULT 0,
    td_odpowiedz text,
    td_datawyk timestamp with time zone,
    m_idkontaktu integer DEFAULT 0,
    zl_idzlecenia integer
);
