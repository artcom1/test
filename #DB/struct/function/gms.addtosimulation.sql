CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 iloscrest   NUMERIC:=_ilosc;
 r           RECORD;
 s           RECORD;
 ilosclocal  NUMERIC;
 cid         INT;
 orderno     INT:=nextval('gms.tm_orderno_s');
 o           gms.tm_ilosci;
 onemoretime    BOOL:=TRUE;
 onemoretimewar BOOL:=FALSE;
 onemoretimeskipped BOOL:=FALSE;
 ilosctmp    NUMERIC;
 maxloops    INT:=50;
 
 iloscrestlocal NUMERIC;
 
 onlyprior   BOOL:=FALSE;    --- Sciagamy tylko ilosci priorytetyzowane
 iloscrestpriorstart NUMERIC;
 ---Uwaga: Mechanizm priorytetow nadaje sie tylko dla WMSMM (nie operuje na rezerwacjach)!

 r1           gms.tm_ilosci;
 r2           gms.tm_ilosci;
 previlosc    NUMERIC;
 q            TEXT;
BEGIN 

 ---RAISE NOTICE 'Ilosc % %',iloscrest,idruchupz;
 ----RAISE NOTICE 'Prms MM % PRT % ILOSC % RUCHPZ %',$3,$4,$5,$6;
 previlosc = iloscrest;

 LOOP
  ---------------------------------------------------------------------------------------------------------------------
  EXIT WHEN (iloscrest<=0) OR (onemoretime=FALSE);
  
  IF (iloscrest<previlosc) THEN
   maxloops=50;
  END IF;
  
  IF (maxloops<0) THEN
   RAISE NOTICE 'MAXLOOPS REACHED!!!!';
   EXIT WHEN TRUE;
  END IF;
  ---------------------------------------------------------------------------------------------------------------------
  onemoretime=FALSE;
  onemoretimewar=FALSE;
  onlyprior=FALSE;
  maxloops=maxloops-1;
  previlosc=min(previlosc,iloscrest);
  
  q='SELECT * FROM
  (
   SELECT *,rank() OVER w AS cnt,
          ((sc.sc_idmiejsca IS NOT DISTINCT FROM '||gm.tostring(idmiejsca)||' AND sc.sc_idpartiipz IS NOT DISTINCT FROM '||gm.tostring(idpartiipz)||'),
		  (CASE WHEN (sc.sc_idpartiipz IS NOT DISTINCT FROM '||gm.tostring(idpartiipz)||' OR '||gm.tostring(idpartiipz)||' IS NULL) THEN 1000
	            WHEN pwz.prt_idpartii IS NOT NULL THEN gm.comparePartie(ppz,pwz,tw.ttw_whereparams)
                ELSE 0 END
	        ),
			(sc.sc_idmiejsca IS NOT DISTINCT FROM '||gm.tostring(idmiejsca)||' OR '||gm.tostring(idmiejsca)||' IS NULL OR ('||gm.tostring(idmiejsca)||'=0 AND sc.sc_idmiejsca IS NULL)),
			(sc.sc_ilosc[0]).l
          ) AS w
   
   FROM gms.tm_simcoll AS sc
   LEFT OUTER JOIN tg_partie AS pwz ON (pwz.prt_idpartii='||gm.tostring(idpartiipz)||' AND '||gm.tostring(idpartiipz)||' IS NOT NULL AND pwz.prt_wplyw<0)
   LEFT OUTER JOIN tg_partie AS ppz ON (ppz.prt_idpartii=sc.sc_idpartiipz AND '||gm.tostring(idpartiipz)||' IS NOT NULL AND pwz.prt_wplyw<0)
   LEFT OUTER JOIN gms.tm_marked AS m ON (m.sc_sid=sc.sc_sid AND m.sc_simid=sc.sc_simid AND m.rc_idruchu=sc.rc_idruchupz)
   LEFT OUTER JOIN tg_towary AS tw ON (tw.ttw_idtowaru=pwz.ttw_idtowaru)
   WHERE sc.sc_sid=vendo.tv_mysessionpid() AND
         sc.sc_simid='||gm.toString(simid)||' AND
         sc.sc_idtowmag='||gm.toString(idtowmag)||' AND
 	(sc.sc_idmiejsca IS NOT DISTINCT FROM '||gm.tostring(idmiejsca)||' OR '||gm.tostring(idmiejsca)||' IS NULL OR ('||gm.tostring(idmiejsca)||'=0 AND sc.sc_idmiejsca IS NULL)) AND
 	(
	 (sc.sc_idpartiipz IS NOT DISTINCT FROM '||gm.tostring(idpartiipz)||' OR '||gm.tostring(idpartiipz)||' IS NULL) OR
	 (pwz.prt_idpartii IS NOT NULL AND (gm.comparePartie(ppz,pwz,tw.ttw_whereparams)>0))
	) AND
	(sc.rc_idruchupz IS NOT DISTINCT FROM '||gm.tostring(idruchupz)||' OR '||gm.tostring(idruchupz)||' IS NULL) AND 
	(gms.hasAnyMark('||gm.toString(simid)||')=FALSE OR (m.gmm_id IS NOT NULL))
   WINDOW w AS (ORDER BY
            (sc.sc_idmiejsca IS NOT DISTINCT FROM '||gm.tostring(idmiejsca)||' AND sc.sc_idpartiipz IS NOT DISTINCT FROM '||gm.tostring(idpartiipz)||') DESC,    --- Najpierw te pozycje gdzie wszystko sie zgadza
            (CASE WHEN (sc.sc_idpartiipz IS NOT DISTINCT FROM '||gm.tostring(idpartiipz)||' OR '||gm.tostring(idpartiipz)||' IS NULL) THEN 1000
	              WHEN pwz.prt_idpartii IS NOT NULL THEN gm.comparePartie(ppz,pwz,tw.ttw_whereparams)
                  ELSE 0 END
	        ) DESC,
            (sc.sc_idmiejsca IS NOT DISTINCT FROM '||gm.tostring(idmiejsca)||' OR '||gm.tostring(idmiejsca)||' IS NULL OR ('||gm.tostring(idmiejsca)||'=0 AND sc.sc_idmiejsca IS NULL)) DESC,
			(sc.sc_iloscpriorited-sc.sc_iloscused>0) DESC,
            ((sc.sc_ilosc[0]).l>0) DESC,
 	    ((sc_ilosc[0]).lnull>0) DESC,
 	    ((sc_ilosc[1]).l>0) DESC,
 	    ((sc_ilosc[1]).lnull>0) DESC,
	    ((sc_ilosc[2]).l>0) DESC,
	    ((sc_ilosc[2]).lnull>0) DESC,
         (sc_ilosc[0]).l DESC,          --- Potem wg. WZetek lokalnych
  	     (sc_ilosc[0]).lnull DESC,      --- Wg. WZetek NULLowych
  	     (sc_ilosc[1]).l DESC,          --- wg. rezerwacji ciezkich nie NULLowych
 	     (sc_ilosc[1]).lnull DESC,      --- wg. rezerwacji ciezkich NULLowych
	     (sc_ilosc[2]).l DESC,          --- wg. rezerwacji lekkich nie NULLowych
	     (sc_ilosc[2]).lnull DESC,      --- wg. rezerwacji lekkich NULLowych
	     rc_idruchupz DESC              --- wg. ID ruchu
	    )
  ) AS a 
  ORDER BY a.cnt';
  ----RAISE NOTICE '%',q;


  FOR r IN EXECUTE q
  LOOP
   EXIT WHEN iloscrest<=0;
   
   iloscrestlocal=iloscrest;
   IF (onlyprior=TRUE) OR (r.sc_iloscpriorited-r.sc_iloscused>0) THEN
    iloscrestlocal=min(iloscrestlocal,r.sc_iloscpriorited-r.sc_iloscused);
   END IF;
   iloscrestpriorstart=iloscrestlocal;

  --- RAISE NOTICE 'Dodaje dla partii % ',r.sc_id;
   ----RAISE NOTICE 'Mam % ',gms.hasAnyMark(simid);
   ---RAISE NOTICE 'Mam % (CNT % %)',r.sc_id,r.cnt,r.w;

---   RAISE NOTICE '%',r;
   ---RAISE NOTICE 'Petla';
   r1=r.sc_ilosc[1];
   r2=r.sc_ilosc[2];

   IF (idruchupz IS NULL) THEN
    -----1. Sprawdz WZetki lokalne z dokladna partia---------------------------------------------------------------------
    ilosclocal=min(iloscrestlocal,(r.sc_ilosc[0]).l);
    IF (ilosclocal>0) THEN
     orderno=nextval('gms.tm_orderno_s');
     o=NULL;
     o.l=ilosclocal;
     PERFORM gms.addOrder(r.sc_id,1,orderno,0,o,0,qdiv);
     iloscrest=iloscrest-ilosclocal;
	 iloscrestlocal=iloscrestlocal-ilosclocal;
	 --- Zrob symulacje od nowa
     onemoretimewar=true;
    END IF;
    -----2. Sprawdz WZetki lokalne z NULLowymi partiami------------------------------------------------------------------
    ilosclocal=min(iloscrestlocal,(r.sc_ilosc[0]).lnull);
    IF (ilosclocal>0) THEN
     orderno=nextval('gms.tm_orderno_s');
     o=NULL;
     o.lnull=ilosclocal;
     PERFORM gms.addOrder(r.sc_id,2,orderno,0,o,0,qdiv);
     iloscrest=iloscrest-ilosclocal;
	 iloscrestlocal=iloscrestlocal-ilosclocal;
	 --- Zrob symulacje od nowa
     onemoretimewar=true;
    END IF;
   END IF;
   IF (idruchupz IS NOT NULL) THEN
    -----3. Sprawdz rezerwacje ciezkie lokalne z dokladna partia---------------------------------------------------------
    ilosclocal=min(iloscrestlocal,r1.l);
    IF (ilosclocal>0) THEN
     orderno=nextval('gms.tm_orderno_s');
     o=NULL;
     o.l=ilosclocal;
     r.sc_iloscpoz=r.sc_iloscpoz-iloscLocal;
     r1.l=r1.l-iloscLocal;
     PERFORM gms.addOrder(r.sc_id,3,orderno,1,o,iloscLocal,qdiv);
     iloscrest=iloscrest-ilosclocal;
	 iloscrestlocal=iloscrestlocal-ilosclocal;
	 --- Zrob symulacje od nowa
     onemoretimewar=true;
    END IF;
    -----4. Sprawdz rezerwacje ciezkie lokalne z NULL partia--------------------------------------------------------------
    ilosclocal=min(iloscrestlocal,r1.lnull);
    IF (ilosclocal>0) THEN
     orderno=nextval('gms.tm_orderno_s');
     o=NULL;
     o.lnull=ilosclocal;
     r.sc_iloscpoz=r.sc_iloscpoz-iloscLocal;
     r1.lnull=r1.lnull-iloscLocal;
     PERFORM gms.addOrder(r.sc_id,4,orderno,1,o,iloscLocal,qdiv);
     iloscrest=iloscrest-ilosclocal;
	 iloscrestlocal=iloscrestlocal-ilosclocal;
	 --- Zrob symulacje od nowa
     onemoretimewar=true;
    END IF;
   END IF;
   IF (idruchupz IS NULL) THEN
    -----5. Sprawdz rezerwacje lekkie lokalne z dokladna partia---------------------------------------------------------
    ilosclocal=min(iloscrestlocal,r2.l);
    IF (ilosclocal>0) THEN
     orderno=nextval('gms.tm_orderno_s');
     o=NULL;
     o.l=ilosclocal;
     r.sc_iloscpoz=r.sc_iloscpoz-iloscLocal;
     r2.l=r2.l-iloscLocal;
     PERFORM gms.addOrder(r.sc_id,5,orderno,2,o,iloscLocal,qdiv);
     iloscrest=iloscrest-ilosclocal;
	 iloscrestlocal=iloscrestlocal-ilosclocal;
	 --- Zrob symulacje od nowa
     onemoretimewar=true;
    END IF;
    -----6. Sprawdz rezerwacje lekkie lokalne z NULL partia--------------------------------------------------------------
    ilosclocal=min(iloscrestlocal,r2.lnull);
    IF (ilosclocal>0) THEN
     orderno=nextval('gms.tm_orderno_s');
     o=NULL;
     o.lnull=ilosclocal;
     r.sc_iloscpoz=r.sc_iloscpoz-iloscLocal;
     r2.lnull=r2.lnull-iloscLocal;
     PERFORM gms.addOrder(r.sc_id,6,orderno,2,o,iloscLocal,qdiv);
     iloscrest=iloscrest-ilosclocal;
	 iloscrestlocal=iloscrestlocal-ilosclocal;
	 --- Zrob symulacje od nowa
     onemoretimewar=true;
    END IF;
    ----7. Sprawdz ilosc pozostala a nie zarezerwowana-----------------------------------------------------------
    ilosclocal=min(iloscrestlocal,r.sc_iloscpoz-
                             r1.pnull-r1.p-
     			     r1.lnull-r1.l-
                             r2.pnull-r2.p-
 			     r2.lnull-r2.l
 	         );
    IF (ilosclocal>0) THEN
	
	 IF (onemoretimewar=TRUE) THEN
      onemoretime=true;
      EXIT WHEN TRUE;	  
	 END IF;
	 
     ilosctmp=gms.moveOthersToThis(r.sc_id,ilosclocal,qdiv);
     IF (ilosctmp>0) THEN
      onemoretime=true;
      EXIT WHEN TRUE;
     END IF;
     orderno=nextval('gms.tm_orderno_s');
     o=NULL;
     r.sc_iloscpoz=r.sc_iloscpoz-iloscLocal;
     PERFORM gms.addOrder(r.sc_id,7,orderno,0,o,iloscLocal,qdiv);
     iloscrest=iloscrest-ilosclocal;
	 iloscrestlocal=iloscrestlocal-ilosclocal;
    END IF;
    ----Sproboj zwolnic partie
	---RAISE NOTICE 'Dodaje % % max %',iloscrestlocal,iloscrest,_ilosc;
	
	IF (onemoretimewar=FALSE) THEN
	
     ilosclocal=gms.tryToFreePartia(r.sc_id,iloscrestlocal,qdiv);
     IF (ilosclocal>0) THEN
 	  RAISE NOTICE 'Onemoretime';
      onemoretime=true;
      EXIT WHEN TRUE;
     END IF;
	 
	ELSE
	 --Wykonaj petle jeszcze raz (na wrazie czego)
	 onemoretimeskipped=TRUE;	 
	END IF;
	
    --Wykorzystalem cos z priorytetu, od tej pory tylko z priorytetem	
	IF (onlyprior=FALSE) AND (iloscrestpriorstart!=iloscrestlocal) THEN	
	 ---RAISE NOTICE '% %',iloscrestpriorstart,iloscrestlocal;
	 onlyprior=TRUE;
	END IF;
	
   END IF;

  END LOOP;
  
  IF (onlyprior=TRUE) OR (onemoretimeskipped=TRUE) THEN
   onemoretime=TRUE;
   onemoretimeskipped=FALSE;
  END IF;

 END LOOP;

 RETURN (_ilosc-iloscrest);
END;
$_$;
