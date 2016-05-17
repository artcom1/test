CREATE TABLE kh_dziennik (
    dz_iddziennika integer DEFAULT nextval(('kh_dziennik_s'::text)::regclass) NOT NULL,
    dz_nazwa text,
    dz_kod text,
    dz_flaga integer DEFAULT 0
);
