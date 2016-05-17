CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _normatyw     ALIAS FOR $1;
 _sumarbh       ALIAS FOR $2;
 _rbh       ALIAS FOR $3;
 wynik      NUMERIC:=0;
BEGIN
 wynik=_normatyw;
 IF (_sumarbh!=0) THEN
  wynik=(_normatyw/_sumarbh)*_rbh;
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
 _normatyw     ALIAS FOR $1;
 _sumarbh       ALIAS FOR $2;
 _rbh       ALIAS FOR $3;
 _iloscprac ALIAS FOR $4;
 wynik      NUMERIC:=0;
BEGIN
 wynik=_normatyw;
 IF (_sumarbh!=0) THEN
  wynik=(_normatyw/_sumarbh)*_rbh;
 ELSE ---gdy nie mamy godzin to dzielimy koszt przez ilosc pracownikow zarejestrowanych pod wykonaniem
  IF (_iloscprac!=0) THEN
   wynik=(_normatyw/_iloscprac);
  END IF;
 END IF; 
 RETURN wynik;
END;
$_$;
