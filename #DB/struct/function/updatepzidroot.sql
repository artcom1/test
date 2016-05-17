CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idplanu ALIAS FOR $1;
 _idref INT;
BEGIN
 
 _idref=(SELECT pz_idref FROM tg_planzlecenia WHERE pz_idplanu=_idplanu);
 
 IF (_idref IS NOT NULL) THEN
  RETURN updatepzidroot(_idref);
 ELSE 
  WITH RECURSIVE t (pz_idplanu,pz_idref) AS 
  ( 
   SELECT pz_idplanu, pz_idref FROM tg_planzlecenia WHERE pz_idref IS NULL AND pz_idplanu=_idplanu UNION 
   SELECT cp.pz_idplanu, _idplanu AS pz_idref FROM tg_planzlecenia AS cp JOIN t ON (cp.pz_idref=t.pz_idplanu) 
  ) 
  UPDATE tg_planzlecenia AS pz SET pz_idroot=t.pz_idref FROM t WHERE pz.pz_idplanu=t.pz_idplanu; 
 END IF;
  
 RETURN 1;
END;
$_$;
