CREATE FUNCTION max(date, date) RETURNS date
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($1>$2) THEN
  RETURN $1;
 ELSE
  RETURN $2;
 END IF;
END;
$_$;


--
--

CREATE FUNCTION max(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 t1 ALIAS FOR $1;
 t2 ALIAS FOR $2;
BEGIN
 
 IF (t1>t2) THEN
  RETURN t1;
 ELSE
  RETURN t2;
 END IF;

END;
$_$;


--
--

CREATE FUNCTION max(timestamp without time zone, timestamp without time zone) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($1>$2) THEN
  RETURN $1;
 END IF;

 RETURN $2;
END
$_$;
