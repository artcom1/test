CREATE FUNCTION rrisflipma(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1&4)<>0 THEN
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END; $_$;
