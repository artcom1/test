CREATE FUNCTION getrodzajkosztu(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 flaga ALIAS FOR $1;
 wynik TEXT;
BEGIN
 wynik='Nieokreslony';
 IF ((flaga&14336)=(1<<11)) THEN
  wynik='Samochod os.';
 END IF;

 IF ((flaga&14336)=(2<<11)) THEN
  wynik='Srodki trwale';
 END IF;

 IF ((flaga&14336)=(3<<11)) THEN
  wynik='Inne';
 END IF;

 IF ((flaga&14336)=(4<<11)) THEN
  wynik='Paliwo nieopodatkowane';
 END IF;

 return wynik;
END;
$_$;
