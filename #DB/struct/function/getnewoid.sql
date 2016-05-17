CREATE FUNCTION getnewoid(text) RETURNS oid
    LANGUAGE plpgsql
    AS $_$
DECLARE
 retoid OID;
BEGIN
 EXECUTE $1;
 GET DIAGNOSTICS retoid = RESULT_OID;
 RETURN retoid; 
END;
$_$;
