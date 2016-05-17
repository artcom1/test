CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem INT;
BEGIN
 
 _idelem=(SELECT tel_idelem FROM tg_transelem WHERE tel_idelem=$1 AND (tel_flaga&(1<<27)<>0));

 IF (_idelem IS NOT NULL) THEN
  RAISE EXCEPTION '35|%|Pozycja zablokowana do zmiany warto??ci',_idelem;
 END IF;

 RETURN TRUE;
END;
$_$;
