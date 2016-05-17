CREATE FUNCTION gettowaridxforkkwnodwyk(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knw_idelemu  ALIAS FOR $1;
 _ttw_idtowaru ALIAS FOR $2;
 
 _ret INT;
 _rec RECORD;
BEGIN
    
 SELECT kwh_towary, ttw_index FROM
 ( 
  SELECT
  UNNEST(kwh_towary) AS kwh_towary,
  UNNEST(array_to_indexarray(kwh_towary)) AS ttw_index
  INTO _rec
  FROM tr_kkwnodwyk AS wyk
  JOIN tr_kkwhead AS head ON (wyk.kwh_idheadu=head.kwh_idheadu)
  WHERE
  knw_idelemu=_knw_idelemu
 ) AS a
 WHERE 
 kwh_towary=_ttw_idtowaru; 
  
 _ret=_rec.ttw_index;
 RETURN _ret;
 
END;
$_$;
