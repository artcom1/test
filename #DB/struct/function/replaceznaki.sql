CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 co ALIAS FOR $1;
 wynik TEXT;
BEGIN
 wynik=replace(co,' ','');
 wynik=replace(wynik,'-','');
 wynik=replace(wynik,',','');
 wynik=replace(wynik,'.','');
 wynik=replace(wynik,';','');
 wynik=replace(wynik,':','');


 RETURN wynik;
END;
$_$;
