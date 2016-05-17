CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 iloscMoved NUMERIC:=0;
 s RECORD;
 iloscLocal NUMERIC;
 r0           gms.tm_ilosci;
 r1           gms.tm_ilosci;
 r2           gms.tm_ilosci;
 s0           gms.tm_ilosci;
 s1           gms.tm_ilosci;
 s2           gms.tm_ilosci;
 rr           gms.tm_ilosci;
 sr           gms.tm_ilosci;
 spoz         NUMERIC;
 -------------------------------
 o            gms.tm_ilosci;
 oo           gms.tm_ilosci;
 orderno      INT;
 i            INT;
 j            INT;
BEGIN


 iloscLocal=min((r.sc_ilosc[0]).pnull+(r.sc_ilosc[1]).pnull+(r.sc_ilosc[2]).pnull+
                (r.sc_ilosc[0]).p+(r.sc_ilosc[1]).p+(r.sc_ilosc[2]).p,maxIlosc);
 IF (iloscLocal<=0) THEN
  RETURN 0;
 END IF;

 r0=r.sc_ilosc[0];
 r1=r.sc_ilosc[1];
 r2=r.sc_ilosc[2];

 ---RAISE NOTICE 'Dzialam dla % ',r.sc_simid;

 FOR s IN SELECT a.* FROM (
  SELECT ss.*
  FROM gms.tm_simcoll AS ss 
  WHERE ss.sc_sid=vendo.tv_mysessionpid() AND ss.sc_simid=(r).sc_simid AND
        ss.sc_idtowmag=(r).sc_idtowmag AND
	(
       (
        ((ss.sc_idpartiipz=r.sc_idpartiipz) AND 
	 ((ss.sc_ilosc[0]).l>0 OR 
	  (ss.sc_ilosc[1]).l>0 OR 
	  (ss.sc_ilosc[2]).l>0)
	 ) OR
        ((ss.sc_ilosc[0]).lnull>0 OR 
	 (ss.sc_ilosc[1]).lnull>0 OR 
	 (ss.sc_ilosc[2]).lnull>0)
	) OR
         ss.sc_iloscpoz
         -(ss.sc_ilosc[1]).pnull-(ss.sc_ilosc[1]).p
         -(ss.sc_ilosc[1]).lnull-(ss.sc_ilosc[1]).l
         -(ss.sc_ilosc[2]).pnull-(ss.sc_ilosc[2]).p
	 -(ss.sc_ilosc[2]).lnull-(ss.sc_ilosc[2]).l>0
	)
   ) AS a 
   ORDER BY (a.sc_idpartiipz=r.sc_idpartiipz) DESC,
            ((a.sc_ilosc[0]).l>0) DESC,
 	    ((a.sc_ilosc[1]).l>0) DESC,
  	    ((a.sc_ilosc[2]).l>0) DESC
  LOOP
   s0=s.sc_ilosc[0];
   s1=s.sc_ilosc[1];
   s2=s.sc_ilosc[2];
   spoz=s.sc_iloscpoz
        -(s.sc_ilosc[1]).pnull-(s.sc_ilosc[1]).p
        -(s.sc_ilosc[1]).lnull-(s.sc_ilosc[1]).l
        -(s.sc_ilosc[2]).pnull-(s.sc_ilosc[2]).p
	-(s.sc_ilosc[2]).lnull-(s.sc_ilosc[2]).l;
 

   CONTINUE WHEN (r.sc_id=s.sc_id);
   
   FOR i IN REVERSE 2..0
   LOOP
    EXIT WHEN maxIlosc<=0;

    CONTINUE WHEN i=1;

    CASE i
     WHEN 0 THEN rr=r0;
     WHEN 1 THEN rr=r1;
     WHEN 2 THEN rr=r2;
     ELSE CONTINUE;
    END CASE;

    FOR j IN 0..3
    LOOP
     CONTINUE WHEN j=1;
     
     CASE j
      WHEN 0 THEN sr=s0;
      WHEN 1 THEN sr=s1;
      WHEN 2 THEN sr=s2;
      WHEN 3 THEN sr=NULL;
      ELSE CONTINUE;
     END CASE;

 
     IF (j=3) THEN
      --------------------------------------------------------------------------------------------------------------------------
      iloscLocal=min(spoz,rr.p);
      iloscLocal=min(iloscLocal,maxIlosc);
      --- Z nie NULLowym
      IF (iloscLocal>0) AND (s.sc_idpartiipz=r.sc_idpartiipz) AND (s.sc_idmiejsca IS DISTINCT FROM r.sc_idmiejsca) THEN
       orderno=nextval('gms.tm_orderno_s');
       ----- Zmnniejsz ilosc p na lokalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       o.p=iloscLocal;
       PERFORM gms.addOrder(r.sc_id,18,orderno,i,o,-iloscLocal,qdiv); 
       ----- Zwieksz ilosc p na zdalnym i zmniejsz stan
       o=NULL;
       o.p=-iloscLocal;
       PERFORM gms.addOrder(s.sc_id,18,orderno,i,o,iloscLocal,qdiv); 
       ----- 
       iloscMoved=iloscMoved+iloscLocal;
       maxIlosc=maxIlosc-iloscLocal;
       rr.p=rr.p-maxIlosc;
       spoz=spoz-maxIlosc;
      END IF;
      --------------------------------------------------------------------------------------------------------------------------
      iloscLocal=min(spoz,rr.pnull);
      iloscLocal=min(iloscLocal,maxIlosc);
      --- Z nie NULLowym
      IF (iloscLocal>0) AND ((s.sc_idpartiipz!=r.sc_idpartiipz) OR (s.sc_idmiejsca IS DISTINCT FROM r.sc_idmiejsca)) THEN
       orderno=nextval('gms.tm_orderno_s');
       ----- Zmnniejsz ilosc p na lokalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       o.pnull=iloscLocal;
       PERFORM gms.addOrder(r.sc_id,17,orderno,i,o,(CASE WHEN i=0 THEN -iloscLocal ELSE 0 END),qdiv); 
       ----- Zwieksz ilosc p na zdalnym i zmniejsz stan
       o=NULL;
       o.pnull=-iloscLocal;
       PERFORM gms.addOrder(s.sc_id,17,orderno,i,o,(CASE WHEN i=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- 
       iloscMoved=iloscMoved+iloscLocal;
       maxIlosc=maxIlosc-iloscLocal;
       rr.pnull=rr.pnull-maxIlosc;
       spoz=spoz-maxIlosc;
      END IF;
      --------------------------------------------------------------------------------------------------------------------------      

     END IF;

     IF (j!=3) THEN
      ----Ilosci p.nieNULL <-> l.nieNULL
      iloscLocal=min(sr.l,rr.p);
      iloscLocal=min(iloscLocal,maxIlosc);
      IF (iloscLocal>0) AND (s.sc_idpartiipz=r.sc_idpartiipz) THEN
       orderno=nextval('gms.tm_orderno_s');
       ----- Zmnniejsz ilosc p na lokalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.p=iloscLocal;
       oo.l=-iloscLocal;
       PERFORM gms.addOrder(r.sc_id,19,orderno,i,o,j,oo,(CASE WHEN i=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- Zmnniejsz ilosc l na zdalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.l=iloscLocal;
       oo.p=-iloscLocal;
       PERFORM gms.addOrder(s.sc_id,19,orderno,j,o,i,oo,(CASE WHEN j=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN i=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- 
       iloscMoved=iloscMoved+iloscLocal;
       maxIlosc=maxIlosc-iloscLocal;
       rr.p=rr.p-maxIlosc;
       sr.l=sr.l-maxIlosc;
      END IF;
      ----Ilosci p.NULL <-> l.nieNULL
      iloscLocal=min(sr.l,rr.pnull);
      iloscLocal=min(iloscLocal,maxIlosc);
      IF (iloscLocal>0) AND (s.sc_idpartiipz=r.sc_idpartiipz) THEN
       orderno=nextval('gms.tm_orderno_s');
       ----- Zmnniejsz ilosc p na lokalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.pnull=iloscLocal;
       oo.l=-iloscLocal;
       PERFORM gms.addOrder(r.sc_id,20,orderno,i,o,j,oo,(CASE WHEN i=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- Zmnniejsz ilosc l na zdalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.l=iloscLocal;
       oo.pnull=-iloscLocal;
       PERFORM gms.addOrder(s.sc_id,20,orderno,j,o,i,oo,(CASE WHEN j=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN i=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- 
       iloscMoved=iloscMoved+iloscLocal;
       maxIlosc=maxIlosc-iloscLocal;
       rr.pnull=rr.pnull-maxIlosc;
       sr.l=sr.l-maxIlosc;
      END IF;
      ----Ilosci p.nieNULL <-> l.NULL
      iloscLocal=min(sr.lnull,rr.p);
      iloscLocal=min(iloscLocal,maxIlosc);
      IF (iloscLocal>0) AND (s.sc_idpartiipz=r.sc_idpartiipz) THEN
       orderno=nextval('gms.tm_orderno_s');
       ----- Zmnniejsz ilosc p na lokalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.p=iloscLocal;
       oo.lnull=-iloscLocal;
       PERFORM gms.addOrder(r.sc_id,21,orderno,i,o,j,oo,(CASE WHEN i=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- Zmnniejsz ilosc l na zdalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.lnull=iloscLocal;
       oo.p=-iloscLocal;
       PERFORM gms.addOrder(s.sc_id,21,orderno,j,o,i,oo,(CASE WHEN j=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN i=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- 
       iloscMoved=iloscMoved+iloscLocal;
       maxIlosc=maxIlosc-iloscLocal;
       rr.p=rr.p-maxIlosc;
       sr.lnull=sr.lnull-maxIlosc;
      END IF;
      ----Ilosci p.NULL <-> l.NULL
      iloscLocal=min(sr.lnull,rr.pnull);
      iloscLocal=min(iloscLocal,maxIlosc);
      IF (iloscLocal>0) THEN
       orderno=nextval('gms.tm_orderno_s');
       ----- Zmnniejsz ilosc p na lokalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.pnull=iloscLocal;
       oo.lnull=-iloscLocal;
       PERFORM gms.addOrder(r.sc_id,22,orderno,i,o,j,oo,(CASE WHEN i=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- Zmnniejsz ilosc l na zdalnym (i zwieksz stan jesli to byla WZetka)
       o=NULL;
       oo=NULL;
       o.lnull=iloscLocal;
       o.pnull=-iloscLocal;
       PERFORM gms.addOrder(s.sc_id,22,orderno,j,o,(CASE WHEN j=0 THEN -iloscLocal ELSE 0 END)+(CASE WHEN i=0 THEN iloscLocal ELSE 0 END),qdiv); 
       ----- 
       iloscMoved=iloscMoved+iloscLocal;
       maxIlosc=maxIlosc-iloscLocal;
       rr.pnull=rr.pnull-maxIlosc;
       sr.lnull=sr.lnull-maxIlosc;
      END IF;
     END IF;

     CASE j
      WHEN 0 THEN s0=sr;
      WHEN 1 THEN s1=sr;
      WHEN 2 THEN s2=sr;
      WHEN 3 THEN sr=NULL;
      ELSE CONTINUE;
     END CASE;

    END LOOP;

    CASE i
     WHEN 0 THEN r0=rr;
     WHEN 1 THEN r1=rr;
     WHEN 2 THEN r2=rr;
     WHEN 3 THEN r2=rr;
     ELSE CONTINUE;
    END CASE;

   END LOOP;
  END LOOP;


 RETURN iloscMoved;
END;
$$;
