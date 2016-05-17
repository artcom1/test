CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 potrzebuje ALIAS FOR $1;
 mam ALIAS FOR $2;
 wynik NUMERIC;
BEGIN
 wynik=potrzebuje;
 IF (mam>0) THEN
   wynik=potrzebuje-mam;
 END IF;
 
 RETURN wynik;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 potrzebuje ALIAS FOR $1;
 mam ALIAS FOR $2;
 uwg_ujemne ALIAS FOR $3;
 wynik NUMERIC;
BEGIN
 wynik=potrzebuje;

 IF (mam>0 OR uwg_ujemne) THEN
   wynik=potrzebuje-mam; 
 END IF;
 
 RETURN wynik;
END;
$_$;
