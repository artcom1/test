CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  cz_klienta ALIAS FOR $1;
  k_idklienta ALIAS FOR $1;
BEGIN
  IF (cz_klienta=k_idklienta) THEN
   RETURN NULL;
  END IF;
 RETURN cz_klienta; 
END;$_$;
