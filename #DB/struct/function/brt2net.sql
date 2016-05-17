CREATE FUNCTION brt2net(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _value ALIAS FOR $1;
 _stawka ALIAS FOR $2;
BEGIN
 RETURN 100*_value/(100+_stawka);
END;
$_$;
