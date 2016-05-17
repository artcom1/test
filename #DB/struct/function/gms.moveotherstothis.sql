CREATE FUNCTION moveotherstothis(scid integer, maxilosc numeric, qdiv text DEFAULT NULL::text) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
 iloscMoved NUMERIC:=0;
 r RECORD;
 s RECORD;
 iloscLocal NUMERIC;
 -------------------------------
 o            gms.tm_ilosci;
 orderno      INT;
 j            INT;
BEGIN

 IF (maxIlosc<=0) THEN
  RETURN 0;
 END IF;
 
 SELECT * INTO r FROM gms.tm_simcoll WHERE sc_id=scid;

 FOR s IN
  SELECT *
  FROM gms.tm_simcoll AS ss 
  WHERE ss.sc_sid=vendo.tv_mysessionpid() AND ss.sc_simid=r.sc_simid AND
        ss.sc_idtowmag=r.sc_idtowmag AND
        ss.sc_id<>r.sc_id AND
        (
         ((ss.sc_idpartiipz=r.sc_idpartiipz) AND ((ss.sc_ilosc[0]).l>0 OR (ss.sc_ilosc[1]).l>0 OR (ss.sc_ilosc[2]).l>0)) OR
         ((ss.sc_ilosc[0]).lnull>0 OR (ss.sc_ilosc[1]).lnull>0 OR (ss.sc_ilosc[2]).lnull>0)
        )
   ORDER BY (ss.sc_idpartiipz=r.sc_idpartiipz) DESC,
            ((ss.sc_ilosc[0]).l>0) DESC,
 	    ((ss.sc_ilosc[1]).l>0) DESC,
  	    ((ss.sc_ilosc[2]).l>0) DESC
 LOOP   
  EXIT WHEN maxIlosc<=0;

  FOR j IN 0..2
  LOOP
   CONTINUE WHEN j=1;
   iloscLocal=min(maxIlosc,(s.sc_ilosc[j]).l);
   IF (iloscLocal>0) AND (s.sc_idpartiipz=r.sc_idpartiipz) THEN
    orderno=nextval('gms.tm_orderno_s');
    ---- Na znalezionym zmniejszam iloscwz_l i zwiekszam o.ilosc
    o=NULL;
    o.l=iloscLocal;
    PERFORM gms.addOrder(s.sc_id,11,orderno,j,o,(CASE WHEN j=0 THEN -iloscLocal ELSE 0 END),qdiv); 
    ---- Na drugim rekordzie zwiekszam iloscwz_l i zwiekszam o.ilosc
    o=NULL;
    o.l=-iloscLocal;
    PERFORM gms.addOrder(r.sc_id,11,orderno,j,o,(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
    ----------------------------------------------------------
    maxIlosc=maxIlosc-iloscLocal;
    iloscMoved=iloscMoved+iloscLocal;
   END IF;
   ---WZety NULLowe
   iloscLocal=min(maxIlosc,(s.sc_ilosc[j]).lnull);
   IF (iloscLocal>0) THEN
    orderno=nextval('gms.tm_orderno_s');
    ---- Na znalezionym zmniejszam iloscwz_l i zwiekszam o.ilosc
    o=NULL;
    o.lnull=iloscLocal;
    PERFORM gms.addOrder(s.sc_id,12,orderno,j,o,(CASE WHEN j=0 THEN -iloscLocal ELSE 0 END),qdiv); 
     ---- Na drugim rekordzie zwiekszam iloscwz_l i zwiekszam o.ilosc
    o=NULL;
    o.lnull=-iloscLocal;
    PERFORM gms.addOrder(r.sc_id,12,orderno,j,o,(CASE WHEN j=0 THEN iloscLocal ELSE 0 END),qdiv); 
    ----------------------------------------------------------
    maxIlosc=maxIlosc-iloscLocal;
    iloscMoved=iloscMoved+iloscLocal;
   END IF;
  END LOOP;

 END LOOP;

 RETURN iloscMoved;
END;
$$;
