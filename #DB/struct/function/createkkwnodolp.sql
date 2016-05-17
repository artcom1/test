CREATE FUNCTION createkkwnodolp(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwh_idheadu ALIAS FOR $1;
 ilerec INT:=-1;
 ino INT:=0;
 r RECORD;
BEGIN
 
 WHILE (ilerec<>0)
 LOOP
  
  SELECT kwe_idelemu INTO r FROM tr_kkwnod 
                     WHERE (kwe_olp IS NULL)
		       AND (
		            (kwe_idelemu NOT IN (SELECT kwe_idnext FROM tr_kkwnodprevnext WHERE kwh_idheadu=_kwh_idheadu))
			    OR (kwe_idelemu IN (SELECT kwe_idnext FROM tr_kkwnodprevnext JOIN tr_kkwnod AS n1 ON (n1.kwe_idelemu=kwe_idprev) WHERE n1.kwh_idheadu=_kwh_idheadu AND kwe_olp IS NOT NULL))
			   )
		      AND kwh_idheadu=_kwh_idheadu LIMIT 1 OFFSET 0;

 UPDATE tr_kkwnod SET kwe_olp=ino+1 WHERE kwe_idelemu=r.kwe_idelemu;
 ino=ino+1;
 ilerec=(SELECT count(*) FROM tr_kkwnod WHERE kwe_olp IS NULL AND kwh_idheadu=_kwh_idheadu);
 END LOOP;

 RETURN TRUE;
END
$_$;
