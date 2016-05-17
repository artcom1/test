CREATE VIEW kv_checksalda AS
 SELECT s.sd_idsalda,
    k.ro_idroku,
    numerkonta(k.kt_prefix, k.kt_numer, (k.kt_zerosto)::integer) AS n,
    s.sd_wn AS sd_wns,
    s.sd_ma AS sd_mas,
    s.sd_wnnr AS sd_wnnrs,
    s.sd_manr AS sd_manrs,
    s.sd_wnpoz AS sd_wnpozs,
    s.sd_mapoz AS sd_mapozs,
    v.sd_wn,
    v.sd_ma,
    v.sd_wnnr,
    v.sd_manr,
    v.sd_wnpoz,
    v.sd_mapoz
   FROM ((kv_salda v
     JOIN kr_salda s USING (sd_idsalda))
     LEFT JOIN kh_konta k USING (kt_idkonta))
  WHERE ((s.sd_wn <> v.sd_wn) OR (s.sd_ma <> v.sd_ma) OR (s.sd_wnnr <> v.sd_wnnr) OR (s.sd_manr <> v.sd_manr) OR (s.sd_wnpoz <> v.sd_wnpoz) OR (s.sd_mapoz <> v.sd_mapoz));
