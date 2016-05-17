CREATE TABLE tm_simorder (
    so_id integer DEFAULT nextval('tm_simorder_s'::regclass) NOT NULL,
    sc_id integer NOT NULL,
    so_ordertype integer NOT NULL,
    so_orderno integer DEFAULT nextval('tm_orderno_s'::regclass) NOT NULL,
    so_ilosci tm_ilosci[] DEFAULT '{"(0,0,0,0)","(0,0,0,0)","(0,0,0,0)"}'::tm_ilosci[],
    so_ilosc numeric DEFAULT 0,
    so_prevsimno integer,
    so_qdiv text
);
