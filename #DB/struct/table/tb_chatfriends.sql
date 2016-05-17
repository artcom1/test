CREATE TABLE tb_chatfriends (
    ctf_id integer DEFAULT nextval('tb_chatfriends_s'::regclass) NOT NULL,
    ctu_id integer NOT NULL,
    ctf_name text NOT NULL,
    ctf_address text NOT NULL,
    ctf_flag integer DEFAULT 0 NOT NULL
);
