CREATE TABLE kh_obroty (
    ob_id integer DEFAULT nextval(('kh_obroty_s'::text)::regclass) NOT NULL,
    kt_idkonta integer NOT NULL,
    ob_wn numeric DEFAULT 0,
    ob_ma numeric DEFAULT 0,
    ob_wnbuf numeric DEFAULT 0,
    ob_mabuf numeric DEFAULT 0,
    mn_miesiac integer,
    ro_idroku integer NOT NULL,
    ob_flaga integer DEFAULT 0,
    ob_ref integer,
    kt_ref integer,
    ob_counter integer DEFAULT 0,
    ob_poziom smallint DEFAULT 0,
    ob_budzetwn numeric DEFAULT 0,
    ob_budzetma numeric DEFAULT 0,
    ob_budzetwnbuf numeric DEFAULT 0,
    ob_budzetmabuf numeric DEFAULT 0
);
