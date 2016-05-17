CREATE FUNCTION getsumarraykkwnod_bykkw(integer) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _kwh_idheadu ALIAS FOR $1;
  recrozm RECORD;
  ret NUMERIC[];
BEGIN
 IF (_kwh_idheadu IS NULL) THEN
  RETURN NULL;
 END IF;
  
 FOR recrozm IN SELECT array_normalize(kwh_towary,kwe_iloscwyk_array) AS arr FROM tr_kkwnod AS nod JOIN tr_kkwhead AS head ON (nod.kwh_idheadu=head.kwh_idheadu) WHERE nod.kwh_idheadu=_kwh_idheadu
 LOOP
  ret=array_plus(recrozm.arr,ret);
 END LOOP;
 
 ret=array_round(ret,4); 
 RETURN ret;
END
$_$;
