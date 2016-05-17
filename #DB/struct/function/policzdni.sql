CREATE FUNCTION policzdni(date, date, date, date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 data_poczatkowa ALIAS FOR $1;
 data_koncowa ALIAS FOR $2;
 data_pocz_odsetek ALIAS FOR $3;
 data_koniec_odsetek ALIAS FOR $4;
 dataod DATE;
 datado DATE;
 wynik INT;
BEGIN
RAISE NOTICE 'Daty: %, %, %, %',data_poczatkowa, data_koncowa, data_pocz_odsetek, data_koniec_odsetek;
 IF (data_poczatkowa<data_pocz_odsetek) THEN 
   dataod=data_pocz_odsetek;
 ELSE
   dataod=data_poczatkowa;
 END IF;
 IF (data_koncowa<data_koniec_odsetek) THEN
   datado=data_koncowa;
 ELSE
   datado=data_koniec_odsetek;
 END IF;
 wynik=datado-dataod;
 ---RAISE NOTICE 'Ilosc dni %, %, %',wynik, datado, dataod;
 return wynik;
END;
$_$;
