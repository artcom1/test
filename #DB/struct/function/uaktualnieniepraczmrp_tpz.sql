CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN uaktualnieniePracZMRP($1,1);
END;
$_$;
