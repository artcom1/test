CREATE FUNCTION floorround(numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN round(floor($1*100)/100,2);    
END
$_$;
