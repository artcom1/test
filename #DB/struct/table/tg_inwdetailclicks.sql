CREATE TABLE tg_inwdetailclicks (
    inc_id integer DEFAULT nextval('tg_inwdetailclicks_s'::regclass) NOT NULL,
    ind_id integer NOT NULL,
    ine_id integer NOT NULL,
    tr_idtrans integer NOT NULL,
    p_idpracownika integer,
    inc_iloscf numeric,
    inc_datasklikania timestamp without time zone DEFAULT now(),
    prt_idpartii integer,
    mm_idmiejsca integer
);
