CREATE FUNCTION ilednizalegloscifaktury(integer, integer, date) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  iledni TEXT;
BEGIN
  IF ($1=$2) THEN
    iledni='Zap??acono';
  ELSE
    iledni=date(now())-date($3);
  END IF;
  RETURN iledni;
END;$_$;


--
--

CREATE FUNCTION ilednizalegloscifaktury(numeric, numeric, date) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  iledni TEXT;
BEGIN
  IF ($1=$2) THEN
    iledni='Zap-acono';
  ELSE
    iledni=date(now())-date($3);
  END IF;
  RETURN iledni;
END;$_$;
