CREATE FUNCTION czymogewykonacoperacjewgmaterialukkwhead(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwh_idheadu ALIAS FOR $1;
 
 _brakujacych INT;
BEGIN 
 
 _brakujacych=(
               SELECT count(*)
   FROM tr_nodrec AS nodrec
   JOIN tg_towmag AS tm USING (ttm_idtowmag)
   WHERE
   nodrec.kwe_idelemu IS NULL AND
   nodrec.kwh_idheadu=_kwh_idheadu AND
   nodrec.knr_wplywmag=-1 AND
   nodrec.knr_flaga&(1<<10)=0 AND
   (nodrec.knr_iloscplan-nodrec.knr_iloscrozch)>tm.ttm_stan
  );
  
 IF (COALESCE(_brakujacych,0)>0) THEN
  RETURN FALSE;
 END IF;
  
 RETURN TRUE;
END;
$_$;
