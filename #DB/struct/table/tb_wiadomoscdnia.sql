CREATE TABLE tb_wiadomoscdnia (
    wd_idwiadomosci integer DEFAULT nextval(('tb_wiadomoscdnia_s'::text)::regclass) NOT NULL,
    wd_tresc text,
    wd_data date DEFAULT now()
);
