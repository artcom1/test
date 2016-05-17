CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _minplan ALIAS FOR $1;
 _maxplan ALIAS FOR $2;
 _the_nextbegin_x ALIAS FOR $3;
 _the_flaga ALIAS FOR $4;

 wynik timestamp without time zone;
BEGIN
 
 IF (_the_flaga&14=0 ) THEN ---po rozplanowaniu nastepna
  wynik=_maxplan;
 ELSE 
  IF (_the_flaga&14=2 ) THEN ---przesuwamy minuty od rozpoczecia wykonania
   wynik=_minplan+(_the_nextbegin_x* interval '1 minute');
  ELSE 
   IF (_the_flaga&14=4 ) THEN ---po okreslonych operacjach, nie umiemy teraz powiedziec dokladnie kiedy wiec ustawiamy na koniec planu
    wynik=_maxplan;
   ELSE 
    IF (_the_flaga&14=6 ) THEN ---przesuwamy minuty od zakonczenia planu
     wynik=_maxplan+(_the_nextbegin_x* interval '1 minute');
    END IF;
   END IF;
  END IF;
 END IF;

 RETURN wynik;
END
$_$;
