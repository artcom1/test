CREATE FUNCTION zmniejszpowiazanieplanu(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pz_idref ALIAS FOR $1;
BEGIN
 IF (pz_idref>0) THEN
   UPDATE tg_powiazanieplanu SET pw_ile=pw_ile-1 WHERE pz_idplanu=pz_idref;
 END IF;
 
 RETURN 0;
END;
$_$;
