CREATE TABLE kh_kontavatowekh (
    kv_idkonta integer DEFAULT nextval(('kh_kontavatowekh_s'::text)::regclass) NOT NULL,
    kt_idkonta integer,
    kv_flaga integer
);
