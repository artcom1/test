CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idmagazynu ALIAS FOR $1;
 _idparent   ALIAS FOR $2;
 r RECORD;
BEGIN

 IF (_idparent IS NULL) THEN
  CREATE TEMP SEQUENCE mmtree_s;
  UPDATE ts_miejscamagazynowe SET mm_l=NULL,mm_r=NULL WHERE mm_magazyn=_idmagazynu;
 END IF;
 
 FOR r IN SELECT mm_idmiejsca 
          FROM ts_miejscamagazynowe 
		  WHERE mm_magazyn=_idmagazynu AND mm_parent IS NOT DISTINCT FROM _idparent
		  ORDER BY (tr_idtransfor IS NULL) DESC,mm_kod ASC
 LOOP
  UPDATE ts_miejscamagazynowe SET mm_l=nextval('mmtree_s') WHERE mm_idmiejsca=r.mm_idmiejsca;
  PERFORM gm.rebuildmmtree(_idmagazynu,r.mm_idmiejsca);
  UPDATE ts_miejscamagazynowe SET mm_r=nextval('mmtree_s') WHERE mm_idmiejsca=r.mm_idmiejsca;  
 END LOOP;

 IF (_idparent IS NULL) THEN
  DROP SEQUENCE mmtree_s;
 END IF;
 
 RETURN TRUE;
END;

$_$;
