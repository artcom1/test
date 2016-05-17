CREATE VIEW kv_salda AS
 SELECT a.sd_idsalda,
    a.sd_wn,
    a.sd_ma,
    a.sd_wnnr,
    a.sd_manr,
    a.sd_wnpoz,
    a.sd_mapoz
   FROM ( SELECT kr_rozrachunki.sd_idsalda,
            sum(kr_rozrachunki.rr_wartoscwnpln) AS sd_wn,
            sum(kr_rozrachunki.rr_wartoscmapln) AS sd_ma,
            sum(
                CASE
                    WHEN (kr_rozrachunki.rr_wartoscpozpln <> (0)::numeric) THEN kr_rozrachunki.rr_wartoscwnpln
                    ELSE (0)::numeric
                END) AS sd_wnnr,
            sum(
                CASE
                    WHEN (kr_rozrachunki.rr_wartoscpozpln <> (0)::numeric) THEN kr_rozrachunki.rr_wartoscmapln
                    ELSE (0)::numeric
                END) AS sd_manr,
            sum(kr_rozrachunki.rr_wartoscwnpozpln) AS sd_wnpoz,
            sum(kr_rozrachunki.rr_wartoscmapozpln) AS sd_mapoz
           FROM kr_rozrachunki
          WHERE ((kr_rozrachunki.rr_isnormal = true) AND (kr_rozrachunki.rr_isbufor = false) AND (kr_rozrachunki.sd_idsalda IS NOT NULL))
          GROUP BY kr_rozrachunki.sd_idsalda) a;
