CREATE TABLE tb_keyscontrollers (
    kct_id integer DEFAULT nextval('tb_keyscontrollers_s'::regclass) NOT NULL,
    kct_controler integer NOT NULL,
    kct_function integer NOT NULL,
    kct_key text
);
