CREATE FUNCTION getsumarraykkwheadrozm_bykkw(integer) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _kwh_idhead   ALIAS FOR $1;
  recrozm RECORD;
  ret NUMERIC[];
BEGIN
 IF (_kwh_idhead IS NULL) THEN
  RETURN NULL;
 END IF;
  
 FOR recrozm IN SELECT kwhr_ilosciwkart, kwhr_ilosckart FROM tr_kkwheadrozm WHERE kwhr_kwh_idheadu=_kwh_idhead
 LOOP
  ret=array_plus(array_multi_single(recrozm.kwhr_ilosciwkart, recrozm.kwhr_ilosckart),ret);
 END LOOP;
 
 ret=array_round(ret,4); 
 RETURN ret;
END
$_$;
