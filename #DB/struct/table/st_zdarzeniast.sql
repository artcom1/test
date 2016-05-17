CREATE TABLE st_zdarzeniast (
    zd_idzdarzenia integer DEFAULT nextval(('st_zdarzeniast_s'::text)::regclass) NOT NULL,
    str_id integer,
    nm_miesiac integer NOT NULL,
    zd_data date NOT NULL,
    p_idpracownika integer,
    zd_opis text,
    zd_zwiekszenie numeric,
    zd_zwiekszeniekoszt numeric,
    fm_idcentrali integer
);
