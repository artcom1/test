CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwhr_idelemu ALIAS FOR $1;
 _rec          RECORD;
BEGIN
  
 FOR _rec IN 
  SELECT
  kwh_towary,
  kwhr_index,
  round(sum(kwhr_ilosciwkart*kwhr_ilosckart),4) AS _il_oczek,
  round(sum(CASE WHEN sum_kwhr_ilosciwkart<>0 THEN (kwhr_ilosciwkart*kwhr_iloscwmag)/(sum_kwhr_ilosciwkart) ELSE 0 END),4) AS _il_wmag,
  round(sum(CASE WHEN sum_kwhr_ilosciwkart<>0 THEN (kwhr_ilosciwkart*kwhr_iloscwmagclosed)/(sum_kwhr_ilosciwkart) ELSE 0 END),4) AS _il_wmag_clos,
  round(sum(CASE WHEN sum_kwhr_ilosciwkart<>0 THEN (kwhr_ilosciwkart*kwhr_iloscwyk)/(sum_kwhr_ilosciwkart) ELSE 0 END),4) AS _il_wyk  
  FROM
  (
   SELECT
   unnest(kwh_towary) AS kwh_towary,
   unnest(array_to_indexarray(kwh_towary)) AS kwhr_index,
   unnest(array_normalize(kwh_towary, kwhr_ilosciwkart)) AS kwhr_ilosciwkart,
   kwhr_iloscwmagclosed, kwhr_iloscwmag, kwhr_ilosckart, kwhr_iloscwyk,
   array_sum(array_normalize(kwh_towary, kwhr_ilosciwkart)) AS sum_kwhr_ilosciwkart
   FROM tr_kkwheadrozm AS rozm JOIN tr_kkwhead AS head ON (kwhr_kwh_idheadu=kwh_idheadu)
   WHERE kwhr_idelemu=_kwhr_idelemu
  ) AS a 
  GROUP BY kwh_towary, kwhr_index
 LOOP
  UPDATE tr_kkwheadrozm SET 
  kwhr_iloscwyk_arr[_rec.kwhr_index]=_rec._il_wyk,
  kwhr_iloscwmag_arr[_rec.kwhr_index]=_rec._il_wmag,
  kwhr_iloscwmagclosed_arr[_rec.kwhr_index]=_rec._il_wmag_clos
  WHERE kwhr_idelemu=_kwhr_idelemu;
 END LOOP;
 
 RETURN 1;  
END;
$_$;
