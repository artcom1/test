CREATE FUNCTION flagmask(integer, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _value ALIAS FOR $1;
 _flag  ALIAS FOR $2;
 _cond  ALIAS FOR $3;
BEGIN

 IF (_cond=true) THEN
  RETURN _value|_flag;
 END IF;

 RETURN _value&(~_flag);
END;
$_$;
