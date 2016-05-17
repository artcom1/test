CREATE FUNCTION iledniwaznoscitowaru(date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  iledni INT;
BEGIN
  IF ($1='2079-11-29' OR $1=NULL) THEN
    iledni=1000000;
  ELSE
    iledni=date($1)-date(now());
  END IF;
  RETURN iledni;
END;$_$;


--
--

CREATE FUNCTION iledniwaznoscitowaru(date, date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  iledni INT;
BEGIN
  IF ($1='2079-11-29' OR $1=NULL) THEN
    iledni=1000000;
  ELSE
    iledni=date($1)-date($2);
  END IF;
  RETURN iledni;
END;$_$;
