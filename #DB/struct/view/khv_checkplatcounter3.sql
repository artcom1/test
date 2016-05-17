CREATE VIEW khv_checkplatcounter3 AS
 SELECT a.pl_idplatnosc,
    a.i,
    a.ile4,
    a.ile3,
    nullzero(zs.zs_counter) AS zs_counter
   FROM (( SELECT ze.pl_idplatnosc,
            count(*) AS i,
            sum(
                CASE
                    WHEN (ze.zp_dorozpisaniaelemswkh IS NOT NULL) THEN 1
                    ELSE 0
                END) AS ile4,
            sum(
                CASE
                    WHEN (nullzero(ze.zp_dorozpisaniaelemswkh) <> 0) THEN 1
                    ELSE 0
                END) AS ile3
           FROM kh_zapisyelem ze
          WHERE (ze.pl_idplatnosc IS NOT NULL)
          GROUP BY ze.pl_idplatnosc) a
     LEFT JOIN kh_zapisskoj zs ON (((a.pl_idplatnosc = zs.pl_idplatnosc) AND (zs.zs_typ = 3))));
