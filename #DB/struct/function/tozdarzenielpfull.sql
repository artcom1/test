CREATE FUNCTION tozdarzenielpfull(text, integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _prefix ALIAS FOR $1;
 _lp ALIAS FOR $2;
BEGIN

 IF ((_prefix IS NULL) OR (_prefix='')) THEN
  RETURN _lp::text;
 END IF;


 RETURN _prefix||'.'||_lp::text;
END;
$_$;


--
--

CREATE FUNCTION tozdarzenielpfull(text, integer, integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _prefix ALIAS FOR $1;
 _lp ALIAS FOR $2;
 _wersja ALIAS FOR $3;
 ret TEXT;
BEGIN
 ret=_lp::text;
 
 IF ((_prefix IS NOT NULL) AND (_prefix<>'')) THEN
  ret=_prefix||'.'||_lp::text;
 END IF;
 
 IF (COALESCE(_wersja,0)>0) THEN
  ret=ret||'/'||_wersja::text;
 END IF;

 RETURN ret;
END;
$_$;
