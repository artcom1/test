CREATE FUNCTION zmienprorytetmiejscmag(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _mm_idmiejsca ALIAS FOR $1;
 typ ALIAS FOR $2;
 mm RECORD;
 mm2 RECORD;
BEGIN
  SELECT mm_idmiejsca, mm_prorytet, mm_magazyn INTO mm FROM ts_miejscamagazynowe WHERE mm_idmiejsca=_mm_idmiejsca;

  IF (typ) THEN
   SELECT mm_idmiejsca, mm_prorytet INTO mm2 FROM ts_miejscamagazynowe WHERE mm_l=(mm_r-1) AND  mm_prorytet<mm.mm_prorytet AND mm_magazyn=mm.mm_magazyn ORDER BY mm_prorytet DESC LIMIT 1 OFFSET 0;
  ELSE
   SELECT mm_idmiejsca, mm_prorytet INTO mm2 FROM ts_miejscamagazynowe WHERE mm_l=(mm_r-1) AND  mm_prorytet>mm.mm_prorytet AND mm_magazyn=mm.mm_magazyn ORDER BY mm_prorytet ASC LIMIT 1 OFFSET 0;
  END IF;

  IF (mm2.mm_idmiejsca>0) THEN
  ---znalazlem miejsce do wymiany prorytetami, robie zamiane
   UPDATE ts_miejscamagazynowe SET mm_prorytet=mm2.mm_prorytet WHERE mm_idmiejsca=mm.mm_idmiejsca;
   UPDATE ts_miejscamagazynowe SET mm_prorytet=mm.mm_prorytet WHERE mm_idmiejsca=mm2.mm_idmiejsca;

   return mm2.mm_idmiejsca;
  END IF;
  RETURN 0;
END;
$_$;
