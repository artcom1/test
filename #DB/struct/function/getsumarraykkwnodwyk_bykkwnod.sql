CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _kwe_idelemu   ALIAS FOR $1;
  recrozm RECORD;
  ret NUMERIC[];
BEGIN
 IF (_kwe_idelemu IS NULL) THEN
  RETURN NULL;
 END IF;
  
 FOR recrozm IN SELECT array_normalize(kwh_towary,knw_iloscwykrozm) AS arr, (CASE WHEN nod.the_flaga&(1<<0)=(1<<0) THEN knw_iloscopakrozm ELSE 1 END) AS knw_iloscopakrozm 
 FROM tr_kkwnodwyk AS nodwyk 
 JOIN tr_kkwnod AS nod ON (nod.kwe_idelemu=nodwyk.kwe_idelemu)
 JOIN tr_kkwhead AS head ON (nodwyk.kwh_idheadu=head.kwh_idheadu) 
 WHERE nod.kwe_idelemu=_kwe_idelemu
 LOOP
  ret=array_plus(array_multi_single(recrozm.arr, recrozm.knw_iloscopakrozm),ret);
 END LOOP;
 
 ret=array_round(ret,4); 
 RETURN ret;
END
$_$;
