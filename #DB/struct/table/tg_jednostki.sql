CREATE TABLE tg_jednostki (
    tjn_idjedn integer DEFAULT nextval(('tg_jednostki_s'::text)::regclass) NOT NULL,
    tjn_nazwa text DEFAULT ''::character varying,
    tjn_skrot text DEFAULT ''::character varying,
    tjn_flaga integer DEFAULT 0,
    tjn_ue text,
    tjn_format integer DEFAULT 0,
    tjn_normalized integer
);
