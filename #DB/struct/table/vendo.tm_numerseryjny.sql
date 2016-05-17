CREATE TABLE tm_numerseryjny (
    vns_id integer DEFAULT nextval('tm_numeryseryjne_s'::regclass) NOT NULL,
    vns_datadodania timestamp without time zone DEFAULT now(),
    vns_dane text,
    vns_registered boolean DEFAULT false,
    vns_extid integer
);
