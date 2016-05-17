CREATE FUNCTION rozliczeniemagazynuprzychodow(numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wartosc ALIAS FOR $1;
 flaga ALIAS FOR $2;
BEGIN
 if ((isPZET(flaga) OR isKPZ(flaga))) THEN
  RETURN wartosc;
 END IF;
 
 RETURN 0;
END;
$_$;
