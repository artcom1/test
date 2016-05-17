CREATE TABLE tg_statystykazapytan (
    sz_idstatystyki integer DEFAULT nextval(('tg_statystykazapytan_s'::text)::regclass) NOT NULL,
    ttw_idtowaru integer,
    p_idpracownika integer,
    sz_data date DEFAULT now(),
    sz_ilosc integer DEFAULT 1,
    sz_komentarz text
);
