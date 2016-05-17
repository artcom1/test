CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pk_idref ALIAS FOR $1;
BEGIN
 IF (pk_idref>0) THEN
   UPDATE tg_powiazaniepaczek SET pp_ile=pp_ile-1 WHERE pk_idpaczki=pk_idref;
 END IF;
 
 RETURN 0;
END;
$_$;
