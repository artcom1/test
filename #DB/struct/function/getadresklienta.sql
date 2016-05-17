CREATE FUNCTION getadresklienta(text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ulica ALIAS FOR $1;
 nrlok ALIAS FOR $2;
 nrdomu ALIAS FOR $3;
 wynik TEXT;
BEGIN
 wynik=ulica;

 IF (trim(nrdomu)!='') THEN
  wynik=wynik||' '||nrdomu;
 END IF;

 IF (trim(nrlok)!='') THEN
  wynik=wynik||'/'||nrlok;
 END IF;

 RETURN wynik;
END;
$_$;
