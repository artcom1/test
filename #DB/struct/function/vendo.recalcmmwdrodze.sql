CREATE FUNCTION recalcmmwdrodze() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

 CREATE TEMP TABLE tmp_mmwdrodze AS 
 SELECT trm.tmg_idmagazynu2,sum(m.tel_iloscf) AS tel_iloscf,m.ttw_idtowaru,NULL::int AS ttm_idtowmag
 FROM tg_transelem AS m 
 JOIN tg_transakcje AS trm ON (m.tr_idtrans=trm.tr_idtrans) 
 LEFT OUTER JOIN tg_transelem AS p ON (p.tel_skojarzony=m.tel_idelem) 
 WHERE trm.tr_rodzaj=6 AND p.tel_idelem IS NULL
 GROUP BY trm.tmg_idmagazynu2,m.ttw_idtowaru;

 UPDATE tmp_mmwdrodze SET ttm_idtowmag=(SELECT ttm_idtowmag FROM tg_towmag AS tm WHERE tm.ttw_idtowaru=tmp_mmwdrodze.ttw_idtowaru AND tm.tmg_idmagazynu=tmp_mmwdrodze.tmg_idmagazynu2);

 INSERT INTO tg_towmag (ttw_idtowaru,tmg_idmagazynu) SELECT ttw_idtowaru,tmg_idmagazynu2 FROM tmp_mmwdrodze WHERE ttm_idtowmag IS NULL;

 UPDATE tmp_mmwdrodze SET ttm_idtowmag=(SELECT ttm_idtowmag FROM tg_towmag AS tm WHERE tm.ttw_idtowaru=tmp_mmwdrodze.ttw_idtowaru AND tm.tmg_idmagazynu=tmp_mmwdrodze.tmg_idmagazynu2) WHERE ttm_idtowmag IS NULL;

 UPDATE tg_towmag SET ttm_mmwdrodze=0 WHERE ttm_mmwdrodze<>0;
 UPDATE tg_towmag SET ttm_mmwdrodze=(SELECT tel_iloscf FROM tmp_mmwdrodze AS m WHERE m.ttm_idtowmag=tg_towmag.ttm_idtowmag) WHERE ttm_idtowmag IN (SELECT ttm_idtowmag FROM tmp_mmwdrodze);

 DROP TABLE tmp_mmwdrodze;

 RETURN TRUE;
END;
$$;
