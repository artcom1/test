CREATE TABLE ts_rozne (
    rn_idrozne integer DEFAULT nextval(('ts_rozne_s'::text)::regclass) NOT NULL,
    rn_typ smallint DEFAULT 0,
    rn_id integer DEFAULT 0,
    rn_value text,
    rn_title text,
    rn_lastchange timestamp without time zone DEFAULT now()
);
