CREATE FUNCTION wn(numeric, integer) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($2>0) THEN
  RETURN $1;
 ELSE
  RETURN NULL;
 END IF;
END;
$_$;


--
--

CREATE FUNCTION wn(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN Wn($1,$2::int);
END;
$_$;