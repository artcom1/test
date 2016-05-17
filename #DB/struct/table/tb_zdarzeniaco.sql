CREATE TABLE tb_zdarzeniaco (
    zdo_id integer DEFAULT nextval('tb_zdarzeniaco_s'::regclass) NOT NULL,
    zd_id integer NOT NULL,
    zdo_reftype integer NOT NULL,
    zdo_refid integer NOT NULL,
    p_idpracownika integer NOT NULL
);
