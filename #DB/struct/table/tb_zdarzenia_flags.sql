CREATE TABLE tb_zdarzenia_flags (
    zdf_id integer DEFAULT nextval('tb_zdarzenia_flags_s'::regclass) NOT NULL,
    zd_idzdarzenia integer NOT NULL,
    p_idpracownika integer,
    zdf_name text,
    zdf_color bigint
);
