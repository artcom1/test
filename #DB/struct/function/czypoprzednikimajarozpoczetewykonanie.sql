CREATE FUNCTION czypoprzednikimajarozpoczetewykonanie(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu ALIAS FOR $1;
 prev RECORD;
BEGIN
 FOR prev IN SELECT kwe_iloscwyk
 FROM tr_kkwnodprevnext AS pn
 JOIN tr_kkwnod AS nod ON (nod.kwe_idelemu=pn.kwe_idprev)
 WHERE
 kwe_idnext=_kwe_idelemu AND
 knpn_flaga&((1<<2)|(1<<3)|(1<<4)) IN (0,(1<<2)) AND
 knpn_flaga&(1<<1)=0
 ORDER BY kwe_idprev ASC
 LOOP
  IF (prev.kwe_iloscwyk=0) THEN
   RETURN FALSE;
  END IF;
 END LOOP;

 RETURN TRUE;
END;
$_$;
