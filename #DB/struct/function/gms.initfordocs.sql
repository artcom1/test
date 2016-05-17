CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmpint    INT;
 t         timestamp:=clock_timestamp();
 rrr       RECORD;
 spid      INT:=vendo.tv_mysessionpid();
 q         TEXT;
BEGIN

 IF (docfv IS NOT NULL) THEN
  idmiejsca_alltowary=NULL;
 END IF;
 
 RAISE NOTICE '1 %',(clock_timestamp()-t);
 t=clock_timestamp();

 ---Dodadza sie wszystkie ruchy gdzie cos pozostalo z pozycji WZ/FV
 IF (docwz IS NOT NULL) THEN 
  IF (idtowmag_alltowary IS NULL) THEN
   PERFORM gms.initSCBlock('(SELECT DISTINCT ttm_idtowmag FROM tg_transelem WHERE '||gm.toString('tr_idtrans',docfv || docwz || -1,true)||')','a',
                           simid::text,'a.ttm_idtowmag',NULL);
   PERFORM gms.initSCBlock('(SELECT DISTINCT ttm_idtowmag FROM tg_wmsmmruch WHERE '||gm.toString('tr_idtrans',docfv || docwz || -1,true)||')','a',
                          simid::text,'a.ttm_idtowmag',NULL);	
  ELSE
   PERFORM gms.initSC(simid,idtowmag_alltowary,NULL);
  END IF;
 END IF;

 RAISE NOTICE '2 %',(clock_timestamp()-t);
 t=clock_timestamp();

 ---Doloz towmagi ktore sa na miejscu
 IF (idmiejsca_alltowary IS NOT NULL) THEN
  --- Czy to wogole cos robi (sprawdzic w starych wersjach triggera)
  PERFORM 1
  FROM (SELECT DISTINCT ttm_idtowmag FROM tg_ruchy AS rpz WHERE (ispzet(rpz.rc_flaga) OR isapzet(rpz.rc_flaga)) AND rpz.rc_iloscpoz>0 AND (rpz.mm_idmiejsca=idmiejsca_alltowary OR (idmiejsca_alltowary=0 AND rpz.mm_idmiejsca IS NULL))) AS a
  WHERE NOT EXISTS (
        SELECT c.sc_id
	FROM gms.tm_simcoll AS c 
	WHERE c.sc_sid=spid AND 
	      c.sc_simid=simid AND 
	      c.sc_idtowmag=a.ttm_idtowmag
	) AND (idtowmag_alltowary IS NULL OR a.ttm_idtowmag IS NOT DISTINCT FROM idtowmag_alltowary);
	
 END IF;

 RAISE NOTICE '3 %',(clock_timestamp()-t);
 t=clock_timestamp();

 ----Doninicjuj pozostale rekordy PZ z WZet (te gdzie w ruchach nic nie bylo)
 IF (TRUE=TRUE) AND (docwz IS NOT NULL) THEN
  q='SELECT DISTINCT r.rc_ruch
     FROM tg_ruchy AS r 
     WHERE r.tr_idtrans='||gm.toString(docwz)||' AND 
           isFV(r.rc_flaga) AND 
          ('||gm.toString(idtowmag_alltowary)||' IS NULL OR r.ttm_idtowmag IS NOT DISTINCT FROM '||gm.toString(idtowmag_alltowary)||') AND
          NOT EXISTS (
           SELECT 1 
    	   FROM gms.tm_simcoll AS c  
	   WHERE c.sc_sid='||spid||' AND 
   	         c.sc_simid='||simid||' AND 
	         c.rc_idruchupz=r.rc_ruch
           ) AND ('||gm.toString(idtowmag_alltowary)||' IS NULL OR r.ttm_idtowmag IS NOT DISTINCT FROM '||gm.toString(idtowmag_alltowary)||')';
   PERFORM gms.initSCBlock(q,'a',simid::text,NULL,'a.rc_ruch');
   q='SELECT DISTINCT r.rc_ruch
     FROM tg_ruchy AS r
	 JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=r.rc_ruch) 
	 JOIN tg_wmsmm AS wms ON (wms.ttm_idtowmag=r.ttm_idtowmag)
	 WHERE wms.tr_idtrans='||gm.toString(docwz)||' AND
	       isFV(r.rc_flaga) AND r.rc_flaga&(1<<28)!=0 AND
		   isPZet(rpz.rc_flaga) AND rpz.rc_iloscpoz=0 AND
		   NOT EXISTS (
           SELECT 1 
    	   FROM gms.tm_simcoll AS c  
	   WHERE c.sc_sid='||spid||' AND 
   	         c.sc_simid='||simid||' AND 
	         c.rc_idruchupz=r.rc_ruch
		   )';
   PERFORM gms.initSCBlock(q,'a',simid::text,NULL,'a.rc_ruch');   
  END IF;


 RAISE NOTICE '4 %',(clock_timestamp()-t);
 t=clock_timestamp();

 ---Uwzglednij WZetki w buforze dla towmagow zgromadzonych powyzej
 PERFORM gms.simulateWZ(simid,idmiejsca_alltowary,idtowmag_alltowary);

 RAISE NOTICE '5 %',(clock_timestamp()-t);
 t=clock_timestamp();

 PERFORM gms.initRezLekkie(simid);

 RAISE NOTICE '6 %',(clock_timestamp()-t);
 t=clock_timestamp();

 ---To co moge uzyc z WZet
 IF (docwz IS NOT NULL) THEN 
  INSERT INTO gms.tm_idtouse
   (sc_simid,ttm_idtowmag,
    rc_idruchuwz,suu_smietnik)
  SELECT simid,r.ttm_idtowmag,
         r.rc_idruchu,gms.useRuchWZ(simid,r.ttm_idtowmag,rpz.mm_idmiejsca,
                       (CASE WHEN gm.getIDNULLPartii(r.ttw_idtowaru,false,-1) IS NOT DISTINCT FROM r.prt_idpartiiwz THEN NULL ELSE rpz.prt_idpartiipz END),
	 	       rpz.rc_idruchu,r.rc_idruchu,r.rc_iloscpoz-r.rc_iloscrezzr)
  FROM tg_ruchy AS r 
  JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=r.rc_ruch)
  LEFT OUTER JOIN gms.tm_allowed AS na ON (na.nal_sid=vendo.tv_mysessionpid() AND na.nal_simid=simid AND na.tel_idelem=r.tel_idelem AND na.tex_idelem IS NOT DISTINCT FROM r.tex_idelem)
  WHERE isFV(r.rc_flaga) AND isPZet(rpz.rc_flaga) AND 
        r.tr_idtrans=docwz AND 
        (idtowmag_alltowary IS NULL OR r.ttm_idtowmag IS NOT DISTINCT FROM idtowmag_alltowary) AND
        r.rc_iloscpoz-r.rc_iloscrezzr>0 AND
        (gms.isAnyAllowed(simid)=false OR (r.tel_idelem IS NOT DISTINCT FROM na.tel_idelem AND r.tex_idelem IS NOT DISTINCT FROM na.tex_idelem));
 END IF;		

 RAISE NOTICE '7 %',(clock_timestamp()-t);
 t=clock_timestamp();

 IF (docwz IS NOT NULL) THEN 
  ---To Co moge uzyc z rezerwacji ciezkiej
  INSERT INTO gms.tm_idtouse
   (sc_simid,ttm_idtowmag,
    rc_idruchurezc,suu_smietnik)
   SELECT simid,rrez.ttm_idtowmag,
          rrez.rc_idruchu, gms.useRuchRezCiezka(simid,rrez.ttm_idtowmag,
                                                (CASE WHEN isRezerwacjaNULL(rrez.rc_flaga) THEN NULL ELSE rpz.mm_idmiejsca END),
                                                (CASE WHEN isRezerwacjaNULL(rrez.rc_flaga) THEN NULL ELSE rpz.prt_idpartiipz END),
                                                rrez.rc_ruch,
                                      	         rrez.rc_idruchu,rrez.rc_iloscrez)
  FROM tg_transelem AS te 
  JOIN tg_ruchy AS rrez ON (rrez.tel_idelem=te.tel_idelem)
  JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=rrez.rc_ruch)
  WHERE isRezerwacja(rrez.rc_flaga) AND NOT isRezerwacjaLekka(rrez.rc_flaga) AND 
        isPZet(rpz.rc_flaga) AND
        te.tr_idtrans = ANY(docfv || docwz || -1) AND 
        (idtowmag_alltowary IS NULL OR te.ttm_idtowmag IS NOT DISTINCT FROM idtowmag_alltowary) AND
        rrez.rc_iloscrez>0;
 END IF;

 RAISE NOTICE '8 %',(clock_timestamp()-t);
 t=clock_timestamp();

 IF (docwz IS NOT NULL) THEN 
 ---To Co moge uzyc z rezerwacji lekkiej
  INSERT INTO gms.tm_idtouse
   (sc_simid,ttm_idtowmag,
    rc_idruchurezl,suu_smietnik)
  SELECT simid,rrez.ttm_idtowmag,
         rrez.rc_idruchu,gms.useRuchRezLekka(simid,rrez.ttm_idtowmag,
                              rrez.prt_idpartiipz,
                              rrez.prt_idpartiiwz,
                              rrez.rc_iloscrez,
 			     isRezerwacjaNULL(rrez.rc_flaga))
  FROM tg_transelem AS te 
  JOIN tg_ruchy AS rrez ON (rrez.tel_idelem=te.tel_idelem)
  WHERE isRezerwacjaLekka(rrez.rc_flaga) AND 
        te.tr_idtrans = ANY(docfv || docwz || -1) AND 
        rrez.rc_iloscrez>0 AND
       (idtowmag_alltowary IS NULL OR te.ttm_idtowmag IS NOT DISTINCT FROM idtowmag_alltowary) AND
       rrez.rc_iloscrez>0;
 END IF;	   
 
 RAISE NOTICE '9 %',(clock_timestamp()-t);
 t=clock_timestamp();

 DELETE FROM gms.tm_idtouse 
 WHERE sc_id=spid AND sc_simid=simid AND rc_idruchuwz_touse IS NOT NULL AND EXISTS
      (
        SELECT rc_idruchuwz FROM gms.tm_idtouse AS u 
	WHERE u.sc_id=spid AND u.sc_simid=simid AND u.rc_idruchuwz IS NOT NULL AND u.rc_idruchuwz=gms.tm_idtouse.rc_idruchuwz_touse
       );

 RAISE NOTICE 'A %',(clock_timestamp()-t);
 t=clock_timestamp();

 RETURN TRUE;
END
$$;
