CREATE FUNCTION przeliczkkwnodwykrozm(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knw_idelemu ALIAS FOR $1;
 _rec         RECORD;
BEGIN
  
 FOR _rec IN 
  SELECT
  kwh_towary,
  kwhr_index,  
  round(sum(CASE WHEN sum_knw_iloscwykrozm<>0 THEN (knw_iloscwykrozm*knw_tomagmag)/(sum_knw_iloscwykrozm) ELSE 0 END),4) AS _il_wmag,
  round(sum(CASE WHEN sum_knw_iloscwykrozm<>0 THEN (knw_iloscwykrozm*knw_tomagmagclosed)/(sum_knw_iloscwykrozm) ELSE 0 END),4) AS _il_wmag_clos
  FROM
  (
   SELECT
   unnest(kwh_towary) AS kwh_towary,
   unnest(array_to_indexarray(kwh_towary)) AS kwhr_index,
   unnest(array_normalize(kwh_towary, knw_iloscwykrozm)) AS knw_iloscwykrozm,   
   knw_tomagmag, knw_tomagmagclosed,
   array_sum(array_normalize(kwh_towary, knw_iloscwykrozm)) AS sum_knw_iloscwykrozm
   FROM tr_kkwnodwyk AS wyk
   JOIN tr_kkwhead AS head ON (wyk.kwh_idheadu=head.kwh_idheadu)
   WHERE knw_idelemu=_knw_idelemu
  ) AS a 
  GROUP BY kwh_towary, kwhr_index
 LOOP
  UPDATE tr_kkwnodwyk SET 
  knw_tomagmag_arr[_rec.kwhr_index]=_rec._il_wmag,
  knw_tomagmagclosed_arr[_rec.kwhr_index]=_rec._il_wmag_clos
  WHERE knw_idelemu=_knw_idelemu;
 END LOOP;
 
 RETURN 1;  
END;
$_$;
