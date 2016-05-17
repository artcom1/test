CREATE TABLE kh_wzorceelem (
    we_idelementu integer DEFAULT nextval(('kh_wzorceelem_s'::text)::regclass) NOT NULL,
    wz_idwzorca integer,
    we_nazwa text,
    we_kontown text,
    we_kontoma text,
    we_opis text,
    we_value text,
    ttw_idtowaru integer,
    we_stawka character varying(4),
    we_flaga integer DEFAULT 0,
    we_slacznik text,
    we_idelementuref integer,
    we_valfunction integer DEFAULT 0,
    we_valuescripturi text
);
