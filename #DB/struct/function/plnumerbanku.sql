CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN trim(translate(translate($1,' ',''),'-',''));
END;
$_$;
