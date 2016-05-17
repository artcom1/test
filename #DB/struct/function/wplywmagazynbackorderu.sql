CREATE FUNCTION wplywmagazynbackorderu(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 bo_flaga ALIAS FOR $1;
 wynik INT:=1;
BEGIN
 IF ((bo_flaga&1)=1) THEN
  wynik=1;
 else
  wynik=-1;
 END IF;
 
 RETURN wynik;
END;
$_$;
