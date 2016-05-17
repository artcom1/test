CREATE TABLE tb_multival (
    v_idvalue integer DEFAULT nextval(('tb_multival_s'::text)::regclass) NOT NULL,
    mv_idvalue integer NOT NULL,
    v_id integer NOT NULL,
    v_value text,
    v_type integer NOT NULL,
    v_valueadd text,
    v_flaga integer DEFAULT 0 NOT NULL,
    skipit boolean DEFAULT false
);
