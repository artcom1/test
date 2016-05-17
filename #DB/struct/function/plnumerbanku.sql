CREATE FUNCTION plnumerbanku(text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN trim(translate(translate($1,' ',''),'-',''));
END;
$_$;
