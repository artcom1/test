CREATE TABLE ts_zrodloinf (
    zi_idzrodla integer DEFAULT nextval(('ts_zrodloinf_s'::text)::regclass) NOT NULL,
    zi_opis text NOT NULL
);
