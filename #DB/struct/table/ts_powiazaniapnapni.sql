CREATE TABLE ts_powiazaniapnapni (
    pnapni_id integer DEFAULT nextval('ts_powiazaniapnapni_s'::regclass) NOT NULL,
    pnapni_pni text NOT NULL,
    pnapni_pna text NOT NULL
);
