CREATE TABLE kh_wzorcekpir (
    wzk_idwzorca integer DEFAULT nextval(('kh_wzorcekpir_s'::text)::regclass) NOT NULL,
    wzk_nazwa text,
    wzk_flaga integer DEFAULT 0,
    wzk_kod text
);
