CREATE FUNCTION changeiloscplanbrak(integer, numeric, numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu       ALIAS FOR $1;
 _kwe_iloscplanwyk  ALIAS FOR $2;
 _kwe_iloscplanbrak ALIAS FOR $3;
BEGIN

 UPDATE tr_kkwnod SET 
  kwe_iloscplanbrak=_kwe_iloscplanbrak,
  kwe_iloscplanwyk=_kwe_iloscplanwyk,
  kwe_iloscplanwyk_array=
  (
   SELECT 
   (CASE WHEN array_sum(kwh_iloscoczek_array)>0 THEN array_round(array_multi_single(kwh_iloscoczek_array,(_kwe_iloscplanwyk/array_sum(kwh_iloscoczek_array))),4) ELSE NULL END) 
   FROM tr_kkwhead AS kwh 
   JOIN tr_kkwnod AS nod ON (kwh.kwh_idheadu=nod.kwh_idheadu)
   WHERE nod.kwe_idelemu=_kwe_idelemu
  ) 
 WHERE
  (kwe_idelemu=_kwe_idelemu) AND
  (kwe_iloscplanwyk<>_kwe_iloscplanwyk OR kwe_iloscplanbrak<>_kwe_iloscplanbrak);

 RETURN TRUE;
END;
$_$;
