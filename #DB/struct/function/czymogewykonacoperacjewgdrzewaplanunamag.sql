CREATE FUNCTION czymogewykonacoperacjewgdrzewaplanunamag(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz_idplanu ALIAS FOR $1;
 prev RECORD;
BEGIN
   
 IF (_pz_idplanu is NULL) THEN
  RETURN TRUE;
 END IF;
    
 FOR prev IN SELECT pz_ilosczreal, pz_flaga FROM tg_planzlecenia WHERE pz_idref=_pz_idplanu
 LOOP 
  IF (prev.pz_flaga&(3<<24)=0) THEN
   CONTINUE;
  END IF;
 
  IF (prev.pz_ilosczreal=0) THEN
   RETURN FALSE;
  END IF;
 END LOOP;
  
 RETURN TRUE;
END;
$_$;
