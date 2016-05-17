CREATE FUNCTION llicznikeq(integer, numeric, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($2=$3) THEN
  RETURN $1;
 ELSE
  RETURN 99999999;
 END IF;
END;
$_$;


--
--

CREATE FUNCTION llicznikeq(integer, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($2=$3) THEN
  RETURN $1;
 ELSE
  RETURN 99999999;
 END IF;
END;
$_$;
