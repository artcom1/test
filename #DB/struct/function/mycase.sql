CREATE FUNCTION mycase(boolean, numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($1) THEN
  RETURN $2;
 ELSE
  RETURN $3;
 END IF;
END; $_$;


--
--

CREATE FUNCTION mycase(boolean, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($1) THEN
  RETURN $2;
 ELSE
  RETURN $3;
 END IF;
END; $_$;
