CREATE TABLE tb_telefony (
    ph_idtelefonu integer DEFAULT nextval('tb_telefony_s'::regclass) NOT NULL,
    ph_datatype integer NOT NULL,
    ph_id integer NOT NULL,
    ph_phone text NOT NULL,
    ph_wewnetrzny integer,
    ph_flaga integer DEFAULT 1,
    ph_comment text,
    ph_type integer DEFAULT 1,
    ph_phonenorm text
);
