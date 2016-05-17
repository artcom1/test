CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 iloscMoved NUMERIC:=0;
 s RECORD;
 iloscLocal NUMERIC;
 i         INT;
 j         INT;
 ----------------------------------------------------------------
 r0           gms.tm_ilosci;
 r1           gms.tm_ilosci;
 r2           gms.tm_ilosci;
 s0           gms.tm_ilosci;
 s1           gms.tm_ilosci;
 s2           gms.tm_ilosci;
 rr           gms.tm_ilosci;
 sr           gms.tm_ilosci;
 o            gms.tm_ilosci;
 oo           gms.tm_ilosci;
 orderno      INT;
 waskey       TEXT;
BEGIN

 iloscLocal=min((r.sc_ilosc[0]).p+(r.sc_ilosc[1]).p+(r.sc_ilosc[2]).p,maxIlosc);
 IF (iloscLocal<=0) THEN
  RETURN 0;
 END IF;

 r0=r.sc_ilosc[0];
 r1=r.sc_ilosc[1];
 r2=r.sc_ilosc[2];

 FOR s IN SELECT a.* FROM (
  SELECT ss.*
  FROM gms.tm_simcoll AS ss 
  WHERE ss.sc_sid=vendo.tv_mysessionpid() AND ss.sc_simid=(r).sc_simid AND
        ss.sc_idtowmag=(r).sc_idtowmag AND
	ss.sc_idmiejsca IS DISTINCT FROM r.sc_idmiejsca AND
	ss.sc_idpartiipz=r.sc_idpartiipz AND
	(
  	 (ss.sc_ilosc[0]).pnull>0 OR
  	 (ss.sc_ilosc[1]).pnull>0 OR
  	 (ss.sc_ilosc[2]).pnull>0
	)
   ) AS a 
   ORDER BY (a.sc_idpartiipz=r.sc_idpartiipz) DESC,
            ((a.sc_ilosc[2]).pnull>0) DESC,
 	    ((a.sc_ilosc[1]).pnull>0) DESC,
  	    ((a.sc_ilosc[0]).pnull>0) DESC
  LOOP
   s0=s.sc_ilosc[0];
   s1=s.sc_ilosc[1];
   s2=s.sc_ilosc[2];

   CONTINUE WHEN (r.sc_id=s.sc_id);

   FOR i IN 0..2
   LOOP
    EXIT WHEN maxIlosc<=0;

    CONTINUE WHEN i=1;

    CASE i
     WHEN 0 THEN rr=r0;
     WHEN 1 THEN rr=r1;
     WHEN 2 THEN rr=r2;
     ELSE CONTINUE;
    END CASE;

    FOR j IN REVERSE 2..0
    LOOP
     CONTINUE WHEN j=1; 

     CASE j
      WHEN 0 THEN sr=s0;
      WHEN 1 THEN sr=s1;
      WHEN 2 THEN sr=s2;
      ELSE CONTINUE;
     END CASE;

     iloscLocal=min(rr.p,sr.pnull);
     iloscLocal=min(maxIlosc,iloscLocal);
     CONTINUE WHEN iloscLocal<=0;

     waskey='gmspnnn'||r.sc_id||'.'||s.sc_id||'.'||i||j;
     CONTINUE WHEN vendo.gettparami(waskey,0)>0;

     PERFORM vendo.settparami(waskey,1);


     orderno=nextval('gms.tm_orderno_s');
     ---- Tu prosta sytuacja podmiany NULLi na nie NULLe
     o=NULL;
     oo=NULL;
     o.p=iloscLocal;
     oo.pnull=-iloscLocal;
     PERFORM gms.addOrder(r.sc_id,23,orderno,i,o,j,oo,(CASE WHEN i=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
     o=NULL;
     oo=NULL;
     o.p=-iloscLocal;
     oo.pnull=iloscLocal;
     PERFORM gms.addOrder(s.sc_id,23,orderno,j,o,i,oo,(CASE WHEN i=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
     iloscMoved=iloscMoved+iloscLocal;
     rr.p=rr.p-iloscLocal;
     sr.pnull=sr.pnull-iloscLocal;

     ---RAISE NOTICE 'Dla ruchu % dokonuje podmiany p<->pNULL',r.sc_id;
    
     CASE j
      WHEN 0 THEN s0=sr;
      WHEN 1 THEN s1=sr;
      WHEN 2 THEN s2=sr;
      ELSE CONTINUE;
     END CASE;

    END LOOP;

    CASE i
     WHEN 0 THEN r0=rr;
     WHEN 1 THEN r1=rr;
     WHEN 2 THEN r2=rr;
     ELSE CONTINUE;
    END CASE;   
   END LOOP;

  END LOOP;


 RETURN iloscMoved;
END;
$$;
