CREATE TABLE tg_ceny (
    tcn_idceny integer DEFAULT nextval('tg_ceny_s'::regclass) NOT NULL,
    ttw_idtowaru integer NOT NULL,
    tgc_idgrupy integer NOT NULL,
    tcn_value numeric DEFAULT 0,
    tcn_valuebrt numeric DEFAULT 0,
    tcn_idwaluty integer DEFAULT 1 NOT NULL,
    tcn_isdefault boolean DEFAULT false NOT NULL,
    tcn_lastchange timestamp without time zone DEFAULT now(),
    tcn_punkty numeric DEFAULT 0,
    p_idpracownika integer,
    tcn_dokladnosc smallint DEFAULT 2
);
