CREATE FUNCTION podajodsetki(numeric, date, date, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 kwota_do_odsetek ALIAS FOR $1;
 data_poczatkowa ALIAS FOR $2;
 data_koncowa ALIAS FOR $3;
 _idrodzajuOdsetek ALIAS FOR $4;
 wynik NUMERIC;
 odsetki RECORD;
 iledni INT;
 query TEXT;
BEGIN
 ---pobieramy obowiazujace odsetki w danym terminie
---- query='SELECT * FROM tg_odsetki WHERE NOT(os_datakoncowa::date<''data_poczatkowa''  OR  os_datapoczatkowa>'||data_koncowa||' )' ;
  query='SELECT * FROM tg_odsetki WHERE ros_idrodzaju='||_idrodzajuOdsetek;
 ---RAISE NOTICE 'Zapytanie: %',query;
 wynik=0;
 FOR odsetki IN EXECUTE query
 LOOP
   IF (odsetki.os_datakoncowa<data_poczatkowa OR odsetki.os_datapoczatkowa>data_koncowa) THEN
    ---nie robimy nic dla tego okresu
   ELSE
     iledni=policzDni(data_poczatkowa,data_koncowa,(odsetki.os_datapoczatkowa-1)::date,odsetki.os_datakoncowa);
     wynik=wynik+round(kwota_do_odsetek*odsetki.os_stawka/100/365*iledni,2);
     ---RAISE NOTICE 'wyniki %, %, %, %', kwota_do_odsetek, odsetki.os_stawka, iledni, wynik;
   END IF;
 END LOOP;

 return wynik;
END;
$_$;
