CREATE FUNCTION nazwapowiazaniakap(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _flaga ALIAS FOR $1;
BEGIN
 IF (_flaga&(1<<25)!=0) THEN 
  return 'Powiazany kapita??owo';
 END IF;

 RETURN 'Bez powiazania kapita??owo';
END;$_$;
