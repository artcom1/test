CREATE TABLE tr_pomiary_powiazania (
    pp_idpowiazania integer DEFAULT nextval('tr_pomiary_powiazania_s'::regclass) NOT NULL,
    pd_iddefinicji integer,
    th_idtechnologii integer,
    ob_idobiektu integer,
    top_idoperacji integer,
    the_idelems integer[],
    pp_wystepowanie integer DEFAULT 0,
    pp_flaga integer DEFAULT 0
);
