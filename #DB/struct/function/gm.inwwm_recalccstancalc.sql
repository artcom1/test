CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 maxoid INT;
 ile INT;
BEGIN

 maxoid=(SELECT max(ind_versioncounter) FROM tg_inwdetails WHERE ind_iloscf_calc!=0 AND tr_idtrans=idtrans);
 
 IF (idmiejsca IS NOT NULL) THEN
  PERFORM gm.inwwm_addinwentaryzacjamm(idtrans,idmiejsca,NULL,0);
 END IF;

 PERFORM count(*) FROM
 (
  WITH lmiejsc AS
  (
   SELECT mm_idmiejsca,ine_id FROM tg_inwelems WHERE tr_idtrans=idtrans AND (idmiejsca IS NULL OR mm_idmiejsca=idmiejsca OR (idmiejsca=0 AND mm_idmiejsca IS NULL))
  ),
  stany AS
  (
   SELECT sum(r.rc_iloscpoz+r.rc_iloscwzbuf) AS iloscf,r.mm_idmiejsca,r.prt_idpartiipz
   FROM tg_ruchy AS r
   JOIN tg_magazyny AS mg ON (mg.tmg_idmagazynu=r.tmg_idmagazynu)
   JOIN lmiejsc ON (lmiejsc.mm_idmiejsca IS NOT DISTINCT FROM r.mm_idmiejsca)
   WHERE isPZet(r.rc_flaga) AND r.rc_iloscpoz+r.rc_iloscwzbuf>0  AND
         mg.fm_idcentrali=(SELECT fm_idcentrali FROM tg_transakcje WHERE tr_idtrans=idtrans) AND
		 (r.tmg_idmagazynu=(SELECT tmg_idmagazynu FROM tg_transakcje WHERE tr_idtrans=idtrans) OR 
		  gm.hasMiejscaMagazynoweWspolne()=TRUE
		 ) 
   GROUP BY r.mm_idmiejsca,r.prt_idpartiipz
  )
  SELECT gm.inwwm_addinwentaryzacjamm(idtrans,stany.mm_idmiejsca,stany.prt_idpartiipz,0,stany.iloscf) FROM stany WHERE stany.iloscf!=0
 ) AS a;

 --- Zupdatuj na 0 te nie poruszone
 UPDATE tg_inwdetails SET ind_iloscf_calc=0 WHERE ind_iloscf_calc!=0 AND tr_idtrans=idtrans AND ind_versioncounter<=maxoid AND (idmiejsca IS NULL OR mm_idmiejsca=idmiejsca);

 RETURN TRUE;
END
$$;
