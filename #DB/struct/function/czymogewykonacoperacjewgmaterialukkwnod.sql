CREATE FUNCTION czymogewykonacoperacjewgmaterialukkwnod(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu ALIAS FOR $1;
 
 _brakujacych INT;
BEGIN 
 
 _brakujacych=(
               SELECT count(*)
   FROM tr_nodrec AS nodrec
   JOIN tg_towmag AS tm USING (ttm_idtowmag)
   WHERE
   nodrec.kwe_idelemu=_kwe_idelemu AND
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
