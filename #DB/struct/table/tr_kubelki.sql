CREATE TABLE tr_kubelki (
    kb_idkubelka integer DEFAULT nextval('tr_kubelki_s'::regclass) NOT NULL,
    zm_idzmiany integer,
    ob_idobiektu integer,
    kb_data date,
    kb_pojemnosc numeric,
    kb_pojemnoscroz numeric DEFAULT 0,
    kb_pojemnoscwyk numeric DEFAULT 0,
    kb_flaga integer DEFAULT 0
);
