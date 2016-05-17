CREATE FUNCTION ccursor(text, text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
 cur REFCURSOR;
BEGIN
 cur:=$1;
 OPEN cur FOR EXECUTE $2;
 RETURN cur;
END;
$_$;
