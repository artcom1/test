CREATE FUNCTION getnewkey(text, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 oid INT;
BEGIN
 EXECUTE $1;
 GET DIAGNOSTICS oid = RESULT_OID;
 RETURN getOID2idRecordu(oid,$2,$3); 
END;
$_$;
