CREATE TABLE tr_ciagtech (
    ct_idciagu integer DEFAULT nextval(('tr_ciagtech_s'::text)::regclass) NOT NULL,
    ct_nazwa text,
    th_rodzaj integer DEFAULT 1,
    ct_flaga integer DEFAULT 0
);
