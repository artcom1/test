CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($2) THEN
  UPDATE kh_platnosci SET pl_flaga=pl_flaga|8192 WHERE pl_idplatnosc=$1;
 ELSE
  UPDATE kh_platnosci SET pl_flaga=pl_flaga&(~8192) WHERE pl_idplatnosc=$1;
 END IF;
 RETURN TRUE;
END;
$_$;
