CREATE FUNCTION datawaznoscitowaru(date) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  iledni TEXT;
BEGIN
  IF ($1='2079-11-29' OR $1=NULL) THEN
    iledni='Bezterminowo';
  ELSE
    iledni=date($1);
  END IF;
  RETURN iledni;
END;$_$;
