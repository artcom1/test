CREATE OR REPLACE FUNCTION 
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

CREATE OR REPLACE FUNCTION 
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
