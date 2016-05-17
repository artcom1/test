CREATE TABLE ts_rabatykwotowe (
    rk_idrabatu integer DEFAULT nextval(('ts_rabatykwotowe_s'::text)::regclass) NOT NULL,
    rk_rabat numeric,
    rk_odkwoty numeric,
    rk_formaplat smallint,
    rk_rabatmax numeric
);
