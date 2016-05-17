CREATE FUNCTION rrisflipwn(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1&2)<>0 THEN
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END; $_$;
